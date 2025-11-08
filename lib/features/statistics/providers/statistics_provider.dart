import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/player_model.dart';
import '../../../core/models/statistics_model.dart';
import '../../../core/services/providers.dart';

final teamStatisticsProvider = FutureProvider.autoDispose<TeamStatistics>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchTeamStatistics();
});

final squadProvider = FutureProvider.autoDispose<List<Player>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchSquad();
});
