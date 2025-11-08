import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class CacheService {
  CacheService._();

  static final CacheService instance = CacheService._();
  Box<dynamic>? _cacheBox;

  Future<void> init() async {
    await Hive.initFlutter();
    _cacheBox ??= await Hive.openBox<dynamic>(AppConstants.cacheBoxName);
  }

  Future<void> saveData(String key, dynamic value) async {
    await _cacheBox?.put(key, value);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('${key}_timestamp', DateTime.now().toIso8601String());
  }

  dynamic getData(String key) => _cacheBox?.get(key);

  Future<DateTime?> getLastUpdated(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final timestamp = prefs.getString('${key}_timestamp');
    if (timestamp == null) return null;
    return DateTime.tryParse(timestamp);
  }

  Future<bool> isCacheValid(String key) async {
    final lastUpdated = await getLastUpdated(key);
    if (lastUpdated == null) return false;
    return DateTime.now().difference(lastUpdated) <= AppConstants.cacheExpiry;
  }
}
