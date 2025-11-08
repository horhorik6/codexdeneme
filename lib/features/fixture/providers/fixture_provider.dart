import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/match_model.dart';
import '../../../core/services/providers.dart';

final fixtureProvider = FutureProvider.autoDispose<List<Match>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchSeasonFixtures();
});
