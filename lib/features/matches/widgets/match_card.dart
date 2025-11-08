import 'package:flutter/material.dart';

import '../../../core/models/match_model.dart';
import '../../../core/utils/date_formatter.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({
    super.key,
    required this.match,
    this.onTap,
  });

  final Match match;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormatter.formatMatchDate(match.date),
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _TeamLabel(teamName: match.homeTeam, alignRight: false)),
                  _ScoreSection(match: match),
                  Expanded(child: _TeamLabel(teamName: match.awayTeam, alignRight: true)),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(match.venue, style: theme.textTheme.bodySmall),
                  Text(_statusText(match.status), style: theme.textTheme.bodySmall),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusText(String status) {
    switch (status) {
      case 'FT':
        return 'Maç Bitti';
      case 'NS':
        return DateFormatter.formatMatchTime(match.date);
      case 'LIVE':
      case '1H':
      case '2H':
        return 'Canlı';
      default:
        return status;
    }
  }
}

class _TeamLabel extends StatelessWidget {
  const _TeamLabel({
    required this.teamName,
    required this.alignRight,
  });

  final String teamName;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    return Text(
      teamName,
      textAlign: alignRight ? TextAlign.right : TextAlign.left,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}

class _ScoreSection extends StatelessWidget {
  const _ScoreSection({required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    final isFinished = match.status == 'FT';
    final isLive = ['LIVE', '1H', '2H'].contains(match.status);
    final scoreText = match.homeScore != null && match.awayScore != null
        ? '${match.homeScore} - ${match.awayScore}'
        : DateFormatter.formatMatchTime(match.date);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          scoreText,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        if (isLive)
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: _LiveIndicator(),
          )
        else if (!isFinished)
          Text(
            DateFormatter.formatMatchTime(match.date),
            style: Theme.of(context).textTheme.bodySmall,
          ),
      ],
    );
  }
}

class _LiveIndicator extends StatelessWidget {
  const _LiveIndicator();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: const [
        Icon(Icons.circle, color: Colors.red, size: 10),
        SizedBox(width: 4),
        Text('CANLI', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
