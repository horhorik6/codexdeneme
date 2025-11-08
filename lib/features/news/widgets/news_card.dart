import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/models/news_model.dart';
import '../../../core/utils/date_formatter.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key, required this.article});

  final NewsArticle article;

  Future<void> _launchArticle() async {
    final uri = Uri.parse(article.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        onTap: _launchArticle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.imageUrl.isNotEmpty)
              CachedNetworkImage(
                imageUrl: article.imageUrl,
                placeholder: (context, _) => const SizedBox(
                  height: 180,
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(article.description),
                  const SizedBox(height: 8),
                  Text(
                    DateFormatter.formatDateTime(article.publishedAt),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
