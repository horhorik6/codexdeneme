import 'package:meta/meta.dart';

@immutable
class Player {
  const Player({
    required this.id,
    required this.name,
    required this.number,
    required this.position,
    required this.age,
    required this.nationality,
    required this.statistics,
    this.photoUrl,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      number: json['number'] as int,
      position: json['position'] as String,
      age: json['age'] as int,
      nationality: json['nationality'] as String,
      statistics: PlayerStatistics.fromJson(json['statistics'] as Map<String, dynamic>),
      photoUrl: json['photoUrl'] as String?,
    );
  }

  final String id;
  final String name;
  final int number;
  final String position;
  final int age;
  final String nationality;
  final PlayerStatistics statistics;
  final String? photoUrl;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'number': number,
        'position': position,
        'age': age,
        'nationality': nationality,
        'statistics': statistics.toJson(),
        'photoUrl': photoUrl,
      };
}

@immutable
class PlayerStatistics {
  const PlayerStatistics({
    required this.matchesPlayed,
    required this.goals,
    required this.assists,
    required this.yellowCards,
    required this.redCards,
    required this.averageRating,
  });

  factory PlayerStatistics.fromJson(Map<String, dynamic> json) {
    return PlayerStatistics(
      matchesPlayed: json['matchesPlayed'] as int? ?? 0,
      goals: json['goals'] as int? ?? 0,
      assists: json['assists'] as int? ?? 0,
      yellowCards: json['yellowCards'] as int? ?? 0,
      redCards: json['redCards'] as int? ?? 0,
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0,
    );
  }

  final int matchesPlayed;
  final int goals;
  final int assists;
  final int yellowCards;
  final int redCards;
  final double averageRating;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'matchesPlayed': matchesPlayed,
        'goals': goals,
        'assists': assists,
        'yellowCards': yellowCards,
        'redCards': redCards,
        'averageRating': averageRating,
      };
}
