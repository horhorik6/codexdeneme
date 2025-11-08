import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/models/match_model.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/providers.dart';

final upcomingMatchesProvider = FutureProvider.autoDispose<List<Match>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchUpcomingMatches();
});

final liveMatchesProvider = FutureProvider.autoDispose<List<Match>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchLiveMatches();
});

final pastMatchesProvider = StateNotifierProvider.autoDispose<PaginatedMatchesNotifier, AsyncValue<List<Match>>>((ref) {
  final api = ref.watch(apiServiceProvider);
  return PaginatedMatchesNotifier(api)
    ..loadInitial();
});

class PaginatedMatchesNotifier extends StateNotifier<AsyncValue<List<Match>>> {
  PaginatedMatchesNotifier(this._api) : super(const AsyncValue.loading());

  final ApiService _api;
  int _page = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> loadInitial() async {
    _page = 1;
    await _fetchMatches(reset: true);
  }

  Future<void> loadMore() async {
    if (!_hasMore) return;
    _page += 1;
    await _fetchMatches(reset: false);
  }

  Future<void> refresh() async {
    _page = 1;
    await _fetchMatches(reset: true);
  }

  Future<void> _fetchMatches({required bool reset}) async {
    try {
      final matches = await _api.fetchPastMatches(page: _page);
      _hasMore = matches.length >= AppConstants.fixturePageSize;
      if (reset) {
        state = AsyncValue.data(matches);
      } else {
        final previous = state.value ?? [];
        state = AsyncValue.data([...previous, ...matches]);
      }
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
