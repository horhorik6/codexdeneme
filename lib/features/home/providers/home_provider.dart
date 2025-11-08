import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/match_model.dart';
import '../../../core/models/news_model.dart';
import '../../../core/models/statistics_model.dart';
import '../../../core/services/providers.dart';
import '../../news/providers/news_provider.dart';
import '../../statistics/providers/statistics_provider.dart';

final lastMatchProvider = FutureProvider.autoDispose<Match?>((ref) async {
  final api = ref.watch(apiServiceProvider);
  final pastMatches = await api.fetchPastMatches(page: 1);
  if (pastMatches.isEmpty) {
    return null;
  }
  return pastMatches.first;
});

final nextMatchProvider = FutureProvider.autoDispose<Match?>((ref) async {
  final api = ref.watch(apiServiceProvider);
  final upcoming = await api.fetchUpcomingMatches();
  if (upcoming.isEmpty) {
    return null;
  }
  return upcoming.first;
});

final homeStatisticsProvider = teamStatisticsProvider;
final homeNewsProvider = newsProvider;
final homeHighlightsProvider = highlightsProvider;
