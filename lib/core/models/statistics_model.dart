import 'package:meta/meta.dart';

@immutable
class TeamStatistics {
  const TeamStatistics({
    required this.form,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.points,
    required this.matchesPlayed,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.cleanSheets,
    required this.yellowCards,
    required this.redCards,
  });

  factory TeamStatistics.fromJson(Map<String, dynamic> json) {
    return TeamStatistics(
      form: json['form'] as List<String>? ?? const [],
      goalsFor: json['goalsFor'] as int? ?? 0,
      goalsAgainst: json['goalsAgainst'] as int? ?? 0,
      points: json['points'] as int? ?? 0,
      matchesPlayed: json['matchesPlayed'] as int? ?? 0,
      wins: json['wins'] as int? ?? 0,
      draws: json['draws'] as int? ?? 0,
      losses: json['losses'] as int? ?? 0,
      cleanSheets: json['cleanSheets'] as int? ?? 0,
      yellowCards: json['yellowCards'] as int? ?? 0,
      redCards: json['redCards'] as int? ?? 0,
    );
  }

  final List<String> form;
  final int goalsFor;
  final int goalsAgainst;
  final int points;
  final int matchesPlayed;
  final int wins;
  final int draws;
  final int losses;
  final int cleanSheets;
  final int yellowCards;
  final int redCards;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'form': form,
        'goalsFor': goalsFor,
        'goalsAgainst': goalsAgainst,
        'points': points,
        'matchesPlayed': matchesPlayed,
        'wins': wins,
        'draws': draws,
        'losses': losses,
        'cleanSheets': cleanSheets,
        'yellowCards': yellowCards,
        'redCards': redCards,
      };
}
