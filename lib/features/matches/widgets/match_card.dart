import 'package:flutter/material.dart';

import '../../../core/models/match_model.dart';
import '../../../core/utils/date_formatter.dart';
import '../../matches/screens/match_detail_screen.dart';

class MatchCard extends StatelessWidget {
  const MatchCard({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MatchDetailScreen(match: match),
          ),
        ),
        title: Text('${match.homeTeam} vs ${match.awayTeam}'),
        subtitle: Text(DateFormatter.formatDateTime(match.date)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (match.homeScore != null && match.awayScore != null)
              Text('${match.homeScore} - ${match.awayScore}',
                  style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(match.status),
          ],
        ),
      ),
    );
  }
}
