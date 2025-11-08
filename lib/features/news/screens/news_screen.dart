import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../providers/news_provider.dart';
import '../widgets/news_card.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final news = ref.watch(newsProvider);
    final highlights = ref.watch(highlightsProvider);

    return Scaffold(
      appBar: const AmedAppBar(title: 'Amedspor Haberleri'),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(newsProvider.future),
            ref.refresh(highlightsProvider.future),
          ]);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Güncel Haberler',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            news.when(
              data: (articles) => Column(
                children: [
                  for (final article in articles)
                    NewsCard(
                      article: article,
                      onTap: () => _openUrl(article.url),
                    ),
                ],
              ),
              loading: LoadingIndicator.new,
              error: (error, stackTrace) => _ErrorState(message: error.toString()),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Maç Özetleri',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            highlights.when(
              data: (videos) => Column(
                children: [
                  for (final video in videos)
                    ListTile(
                      leading: const Icon(Icons.play_circle_fill),
                      title: Text(video.title),
                      subtitle: Text(video.source ?? 'YouTube'),
                      onTap: () => _openUrl(video.url),
                    ),
                ],
              ),
              loading: LoadingIndicator.new,
              error: (error, stackTrace) => _ErrorState(message: error.toString()),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('URL açılamadı: $url');
    }
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Text('Lütfen daha sonra tekrar deneyin.'),
        ],
      ),
    );
  }
}
