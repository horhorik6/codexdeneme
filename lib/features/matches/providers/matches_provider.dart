import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/models/match_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/cache_service.dart';
import '../../../core/utils/error_handler.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final matchesProvider = StateNotifierProvider<MatchesNotifier, AsyncValue<List<Match>>>(
  (ref) => MatchesNotifier(ref.read(apiServiceProvider)),
);

class MatchesNotifier extends StateNotifier<AsyncValue<List<Match>>> {
  MatchesNotifier(this._apiService) : super(const AsyncValue.loading()) {
    _init();
  }

  final ApiService _apiService;
  Timer? _liveRefreshTimer;

  Future<void> _init() async {
    await CacheService.instance.init();
    await loadMatches();
    _startLiveRefresh();
  }

  Future<void> loadMatches() async {
    state = const AsyncValue.loading();

    try {
      final cached = CacheService.instance.getData(AppConstants.matchesCollection);
      if (cached != null) {
        final matches = (cached as List<dynamic>)
            .map((json) => Match.fromJson(Map<String, dynamic>.from(json as Map)))
            .toList();
        state = AsyncValue.data(matches);
      }

      final response = await _apiService.getUpcomingMatches();
      final data = response.data as Map<String, dynamic>;
      final fixtures = (data['response'] as List<dynamic>? ?? [])
          .map((fixture) => Match(
                id: fixture['fixture']['id'].toString(),
                date: DateTime.parse(fixture['fixture']['date'] as String),
                homeTeam: fixture['teams']['home']['name'] as String,
                awayTeam: fixture['teams']['away']['name'] as String,
                status: fixture['fixture']['status']['short'] as String,
                venue: fixture['fixture']['venue']['name'] as String? ?? 'N/A',
                events: const [],
                statistics: null,
              ))
          .toList();

      state = AsyncValue.data(fixtures);
      await CacheService.instance.saveData(
        AppConstants.matchesCollection,
        fixtures.map((match) => match.toJson()).toList(),
      );
    } catch (error, stackTrace) {
      ErrorHandler.logError(error, stackTrace);
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshLiveMatches() async {
    try {
      final response = await _apiService.getLiveMatches();
      final data = response.data as Map<String, dynamic>;
      final liveMatches = (data['response'] as List<dynamic>? ?? [])
          .map((fixture) => Match(
                id: fixture['fixture']['id'].toString(),
                date: DateTime.parse(fixture['fixture']['date'] as String),
                homeTeam: fixture['teams']['home']['name'] as String,
                awayTeam: fixture['teams']['away']['name'] as String,
                homeScore: fixture['goals']['home'] as int?,
                awayScore: fixture['goals']['away'] as int?,
                status: fixture['fixture']['status']['short'] as String,
                venue: fixture['fixture']['venue']['name'] as String? ?? 'N/A',
                events: const [],
                statistics: null,
              ))
          .toList();

      state.whenData((matches) {
        final updated = matches.map((match) {
          final liveMatch = liveMatches.firstWhere(
            (live) => live.id == match.id,
            orElse: () => match,
          );
          return liveMatch;
        }).toList();
        state = AsyncValue.data(updated);
      });
    } catch (error, stackTrace) {
      ErrorHandler.logError(error, stackTrace);
    }
  }

  void _startLiveRefresh() {
    _liveRefreshTimer?.cancel();
    _liveRefreshTimer = Timer.periodic(
      AppConstants.liveRefreshInterval,
      (_) => refreshLiveMatches(),
    );
  }

  @override
  void dispose() {
    _liveRefreshTimer?.cancel();
    super.dispose();
  }
}
