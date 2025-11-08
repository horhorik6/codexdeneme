import 'package:equatable/equatable.dart';

class PremiumContent extends Equatable {
  const PremiumContent({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    this.publishedAt,
    this.tag,
  });

  final String id;
  final String title;
  final String description;
  final String? imageUrl;
  final DateTime? publishedAt;
  final String? tag;

  PremiumContent copyWith({
    String? id,
    String? title,
    String? description,
    String? imageUrl,
    DateTime? publishedAt,
    String? tag,
  }) {
    return PremiumContent(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      publishedAt: publishedAt ?? this.publishedAt,
      tag: tag ?? this.tag,
    );
  }

  factory PremiumContent.fromJson(Map<String, dynamic> json) {
    return PremiumContent(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      publishedAt: json['published_at'] != null
          ? DateTime.tryParse(json['published_at'] as String)
          : null,
      tag: json['tag'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'image_url': imageUrl,
      'published_at': publishedAt?.toIso8601String(),
      'tag': tag,
    };
  }

  @override
  List<Object?> get props => [id, title, description, imageUrl, publishedAt, tag];
}

class PremiumState extends Equatable {
  const PremiumState({
    required this.isSubscribed,
    this.exclusives = const [],
    this.perks = const [],
    this.featuredVideo,
  });

  final bool isSubscribed;
  final List<PremiumContent> exclusives;
  final List<String> perks;
  final String? featuredVideo;

  PremiumState copyWith({
    bool? isSubscribed,
    List<PremiumContent>? exclusives,
    List<String>? perks,
    String? featuredVideo,
  }) {
    return PremiumState(
      isSubscribed: isSubscribed ?? this.isSubscribed,
      exclusives: exclusives ?? this.exclusives,
      perks: perks ?? this.perks,
      featuredVideo: featuredVideo ?? this.featuredVideo,
    );
  }

  static PremiumState initial() {
    return const PremiumState(
      isSubscribed: false,
      perks: <String>[
        'Canlı maç içi taktik analizleri',
        'Süper HD maç özetleri',
        'Anlık transfer dedikoduları',
        'Uzmanlardan maç önü analizleri',
      ],
    );
  }

  @override
  List<Object?> get props => [isSubscribed, exclusives, perks, featuredVideo];
}
