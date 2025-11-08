import 'package:flutter/material.dart';

import '../../../core/models/news_model.dart';
import '../widgets/news_card.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  final List<NewsArticle> _news = const [];

  @override
  Widget build(BuildContext context) {
    if (_news.isEmpty) {
      return const Center(child: Text('Haber bulunamadı.'));
    }

    return ListView.builder(
      itemCount: _news.length,
      itemBuilder: (context, index) => NewsCard(article: _news[index]),
    );
  }
}
