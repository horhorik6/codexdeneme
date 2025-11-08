class TeamStatistics {
  final int played;
  final int wins;
  final int draws;
  final int losses;
  final int goalsFor;
  final int goalsAgainst;
  final int cleanSheets;
  final double averageGoalsPerMatch;

  const TeamStatistics({
    required this.played,
    required this.wins,
    required this.draws,
    required this.losses,
    required this.goalsFor,
    required this.goalsAgainst,
    required this.cleanSheets,
    required this.averageGoalsPerMatch,
  });

  factory TeamStatistics.empty() => const TeamStatistics(
        played: 0,
        wins: 0,
        draws: 0,
        losses: 0,
        goalsFor: 0,
        goalsAgainst: 0,
        cleanSheets: 0,
        averageGoalsPerMatch: 0,
      );

  factory TeamStatistics.fromJson(Map<String, dynamic> json) => TeamStatistics(
        played: json['played'] as int,
        wins: json['wins'] as int,
        draws: json['draws'] as int,
        losses: json['losses'] as int,
        goalsFor: json['goalsFor'] as int,
        goalsAgainst: json['goalsAgainst'] as int,
        cleanSheets: json['cleanSheets'] as int,
        averageGoalsPerMatch: (json['averageGoalsPerMatch'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'played': played,
        'wins': wins,
        'draws': draws,
        'losses': losses,
        'goalsFor': goalsFor,
        'goalsAgainst': goalsAgainst,
        'cleanSheets': cleanSheets,
        'averageGoalsPerMatch': averageGoalsPerMatch,
      };
}
