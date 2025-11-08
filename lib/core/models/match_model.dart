import 'package:collection/collection.dart';

class Match {
  final String id;
  final DateTime date;
  final String homeTeam;
  final String awayTeam;
  final int? homeScore;
  final int? awayScore;
  final String status; // scheduled, live, finished
  final String venue;
  final List<MatchEvent> events;
  final MatchStatistics? statistics;

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

  bool get isLive => status.toLowerCase() == 'live';
  bool get isFinished => status.toLowerCase() == 'finished';
  bool get isScheduled => status.toLowerCase() == 'scheduled';

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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'homeTeam': homeTeam,
      'awayTeam': awayTeam,
      'homeScore': homeScore,
      'awayScore': awayScore,
      'status': status,
      'venue': venue,
      'events': events.map((e) => e.toJson()).toList(),
      'statistics': statistics?.toJson(),
    };
  }

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as String,
      date: DateTime.parse(json['date'] as String),
      homeTeam: json['homeTeam'] as String,
      awayTeam: json['awayTeam'] as String,
      homeScore: json['homeScore'] as int?,
      awayScore: json['awayScore'] as int?,
      status: json['status'] as String,
      venue: json['venue'] as String,
      events: (json['events'] as List<dynamic>? ?? [])
          .map((e) => MatchEvent.fromJson(e as Map<String, dynamic>))
          .toList(),
      statistics: json['statistics'] == null
          ? null
          : MatchStatistics.fromJson(
              json['statistics'] as Map<String, dynamic>,
            ),
    );
  }
}

class MatchEvent {
  final String type; // goal, card, substitution
  final int minute;
  final String player;
  final String? detail;

  const MatchEvent({
    required this.type,
    required this.minute,
    required this.player,
    this.detail,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'minute': minute,
        'player': player,
        'detail': detail,
      };

  factory MatchEvent.fromJson(Map<String, dynamic> json) => MatchEvent(
        type: json['type'] as String,
        minute: json['minute'] as int,
        player: json['player'] as String,
        detail: json['detail'] as String?,
      );
}

class MatchStatistics {
  final int possessionHome;
  final int possessionAway;
  final int shotsHome;
  final int shotsAway;
  final int cornersHome;
  final int cornersAway;

  const MatchStatistics({
    required this.possessionHome,
    required this.possessionAway,
    required this.shotsHome,
    required this.shotsAway,
    required this.cornersHome,
    required this.cornersAway,
  });

  Map<String, dynamic> toJson() => {
        'possessionHome': possessionHome,
        'possessionAway': possessionAway,
        'shotsHome': shotsHome,
        'shotsAway': shotsAway,
        'cornersHome': cornersHome,
        'cornersAway': cornersAway,
      };

  factory MatchStatistics.fromJson(Map<String, dynamic> json) => MatchStatistics(
        possessionHome: json['possessionHome'] as int,
        possessionAway: json['possessionAway'] as int,
        shotsHome: json['shotsHome'] as int,
        shotsAway: json['shotsAway'] as int,
        cornersHome: json['cornersHome'] as int,
        cornersAway: json['cornersAway'] as int,
      );
}

extension MatchListExtensions on List<Match> {
  List<Match> sortByDateDesc() => [...this]
    ..sort((a, b) => b.date.compareTo(a.date));

  Match? get latestFinished => firstWhereOrNull((match) => match.isFinished);
}
