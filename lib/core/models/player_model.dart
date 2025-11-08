class Player {
  final String id;
  final String name;
  final int number;
  final String position;
  final int age;
  final String nationality;
  final String photoUrl;
  final PlayerStatistics statistics;

  const Player({
    required this.id,
    required this.name,
    required this.number,
    required this.position,
    required this.age,
    required this.nationality,
    required this.photoUrl,
    required this.statistics,
  });

  Player copyWith({
    String? id,
    String? name,
    int? number,
    String? position,
    int? age,
    String? nationality,
    String? photoUrl,
    PlayerStatistics? statistics,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      number: number ?? this.number,
      position: position ?? this.position,
      age: age ?? this.age,
      nationality: nationality ?? this.nationality,
      photoUrl: photoUrl ?? this.photoUrl,
      statistics: statistics ?? this.statistics,
    );
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      name: json['name'] as String,
      number: json['number'] as int,
      position: json['position'] as String,
      age: json['age'] as int,
      nationality: json['nationality'] as String,
      photoUrl: json['photoUrl'] as String? ?? '',
      statistics: PlayerStatistics.fromJson(
        json['statistics'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'number': number,
        'position': position,
        'age': age,
        'nationality': nationality,
        'photoUrl': photoUrl,
        'statistics': statistics.toJson(),
      };
}

class PlayerStatistics {
  final int matchesPlayed;
  final int goals;
  final int assists;
  final int yellowCards;
  final int redCards;

  const PlayerStatistics({
    required this.matchesPlayed,
    required this.goals,
    required this.assists,
    required this.yellowCards,
    required this.redCards,
  });

  factory PlayerStatistics.fromJson(Map<String, dynamic> json) {
    return PlayerStatistics(
      matchesPlayed: json['matchesPlayed'] as int,
      goals: json['goals'] as int,
      assists: json['assists'] as int,
      yellowCards: json['yellowCards'] as int,
      redCards: json['redCards'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'matchesPlayed': matchesPlayed,
        'goals': goals,
        'assists': assists,
        'yellowCards': yellowCards,
        'redCards': redCards,
      };
}
