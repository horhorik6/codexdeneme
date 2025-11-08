import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/news_model.dart';
import '../../../core/services/providers.dart';

final newsProvider = FutureProvider.autoDispose<List<NewsArticle>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchNews();
});

final highlightsProvider = FutureProvider.autoDispose<List<NewsArticle>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.fetchYoutubeHighlights();
});
