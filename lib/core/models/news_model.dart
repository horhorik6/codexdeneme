import 'package:meta/meta.dart';

@immutable
class NewsArticle {
  const NewsArticle({
    required this.id,
    required this.title,
    required this.summary,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    this.source,
    this.videoUrl,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      id: json['id'] as String,
      title: json['title'] as String,
      summary: json['summary'] as String? ?? json['description'] as String? ?? '',
      url: json['url'] as String,
      imageUrl: json['imageUrl'] as String? ?? '',
      publishedAt: DateTime.parse(json['publishedAt'] as String),
      source: json['source'] as String?,
      videoUrl: json['videoUrl'] as String?,
    );
  }

  final String id;
  final String title;
  final String summary;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;
  final String? source;
  final String? videoUrl;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'summary': summary,
        'url': url,
        'imageUrl': imageUrl,
        'publishedAt': publishedAt.toIso8601String(),
        'source': source,
        'videoUrl': videoUrl,
      };
}
