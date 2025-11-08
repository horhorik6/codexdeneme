import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';

class CacheService {
  CacheService._();

  static final CacheService instance = CacheService._();

  Box<dynamic>? _cacheBox;
  SharedPreferences? _preferences;

  Future<void> init() async {
    await Hive.initFlutter();
    _cacheBox ??= await Hive.openBox<dynamic>(AppConstants.cacheBoxName);
    _preferences ??= await SharedPreferences.getInstance();
  }

  Future<void> saveData(String key, Object value) async {
    await init();
    await _cacheBox?.put(key, jsonEncode(value));
    await _preferences?.setString('${key}_timestamp', DateTime.now().toIso8601String());
  }

  T? readData<T>(String key, T Function(Map<String, dynamic>) fromJson) {
    if (_cacheBox == null) return null;
    final raw = _cacheBox?.get(key) as String?;
    if (raw == null) return null;
    final Map<String, dynamic> json = jsonDecode(raw) as Map<String, dynamic>;
    return fromJson(json);
  }

  List<T> readList<T>(
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    if (_cacheBox == null) return [];
    final raw = _cacheBox?.get(key) as String?;
    if (raw == null) return [];
    final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
    return jsonList.map((dynamic item) => fromJson(item as Map<String, dynamic>)).toList();
  }

  bool isExpired(String key) {
    final timestamp = _preferences?.getString('${key}_timestamp');
    if (timestamp == null) {
      return true;
    }
    final updatedAt = DateTime.tryParse(timestamp);
    if (updatedAt == null) {
      return true;
    }
    return DateTime.now().difference(updatedAt) > AppConstants.cacheExpiry;
  }

  Future<void> clearCache() async {
    await _cacheBox?.clear();
  }
}
