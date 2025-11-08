class NewsArticle {
  final String id;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;
  final String source;
  final String? videoUrl;

  const NewsArticle({
    required this.id,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
    required this.source,
    this.videoUrl,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) => NewsArticle(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        url: json['url'] as String,
        imageUrl: json['imageUrl'] as String? ?? '',
        publishedAt: DateTime.parse(json['publishedAt'] as String),
        source: json['source'] as String? ?? 'Unknown',
        videoUrl: json['videoUrl'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'url': url,
        'imageUrl': imageUrl,
        'publishedAt': publishedAt.toIso8601String(),
        'source': source,
        'videoUrl': videoUrl,
      };
}
