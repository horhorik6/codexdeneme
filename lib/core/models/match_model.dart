import 'package:meta/meta.dart';

@immutable
class Match {
  const Match({
    required this.id,
    required this.date,
    required this.homeTeam,
    required this.awayTeam,
    this.homeScore,
    this.awayScore,
    required this.status,
    required this.venue,
    this.events = const [],
    this.statistics,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      homeTeam: json['homeTeam'] as String,
      awayTeam: json['awayTeam'] as String,
      homeScore: json['homeScore'] as int?,
      awayScore: json['awayScore'] as int?,
      status: json['status'] as String,
      venue: json['venue'] as String? ?? 'Bilinmiyor',
      events: (json['events'] as List<dynamic>? ?? [])
          .map((dynamic event) => MatchEvent.fromJson(event as Map<String, dynamic>))
          .toList(),
      statistics: json['statistics'] == null
          ? null
          : MatchStatistics.fromJson(json['statistics'] as Map<String, dynamic>),
    );
  }

  final String id;
  final DateTime date;
  final String homeTeam;
  final String awayTeam;
  final int? homeScore;
  final int? awayScore;
  final String status;
  final String venue;
  final List<MatchEvent> events;
  final MatchStatistics? statistics;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'date': date.toIso8601String(),
        'homeTeam': homeTeam,
        'awayTeam': awayTeam,
        'homeScore': homeScore,
        'awayScore': awayScore,
        'status': status,
        'venue': venue,
        'events': events.map((event) => event.toJson()).toList(),
        'statistics': statistics?.toJson(),
      };

  Match copyWith({
    String? id,
    DateTime? date,
    String? homeTeam,
    String? awayTeam,
    int? homeScore,
    int? awayScore,
    String? status,
    String? venue,
    List<MatchEvent>? events,
    MatchStatistics? statistics,
  }) {
    return Match(
      id: id ?? this.id,
      date: date ?? this.date,
      homeTeam: homeTeam ?? this.homeTeam,
      awayTeam: awayTeam ?? this.awayTeam,
      homeScore: homeScore ?? this.homeScore,
      awayScore: awayScore ?? this.awayScore,
      status: status ?? this.status,
      venue: venue ?? this.venue,
      events: events ?? this.events,
      statistics: statistics ?? this.statistics,
    );
  }
}

@immutable
class MatchEvent {
  const MatchEvent({
    required this.minute,
    required this.type,
    required this.team,
    this.player,
    this.assist,
    this.detail,
  });

  factory MatchEvent.fromJson(Map<String, dynamic> json) {
    return MatchEvent(
      minute: json['minute'] as int? ?? 0,
      type: json['type'] as String? ?? 'event',
      team: json['team'] as String? ?? 'Amedspor',
      player: json['player'] as String?,
      assist: json['assist'] as String?,
      detail: json['detail'] as String?,
    );
  }

  final int minute;
  final String type;
  final String team;
  final String? player;
  final String? assist;
  final String? detail;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'minute': minute,
        'type': type,
        'team': team,
        'player': player,
        'assist': assist,
        'detail': detail,
      };
}

@immutable
class MatchStatistics {
  const MatchStatistics({
    required this.possession,
    required this.shotsOnTarget,
    required this.totalShots,
    required this.corners,
    required this.fouls,
  });

  factory MatchStatistics.fromJson(Map<String, dynamic> json) {
    return MatchStatistics(
      possession: (json['possession'] as num?)?.toDouble() ?? 0,
      shotsOnTarget: json['shotsOnTarget'] as int? ?? 0,
      totalShots: json['totalShots'] as int? ?? 0,
      corners: json['corners'] as int? ?? 0,
      fouls: json['fouls'] as int? ?? 0,
    );
  }

  final double possession;
  final int shotsOnTarget;
  final int totalShots;
  final int corners;
  final int fouls;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'possession': possession,
        'shotsOnTarget': shotsOnTarget,
        'totalShots': totalShots,
        'corners': corners,
        'fouls': fouls,
      };
}
