import 'package:flutter/material.dart';

import '../../../core/models/match_model.dart';

class LiveScoreWidget extends StatelessWidget {
  const LiveScoreWidget({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${match.homeTeam} vs ${match.awayTeam}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                '${match.homeScore ?? '-'} : ${match.awayScore ?? '-'}',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Text('Durum: ${match.status}'),
          ],
        ),
      ),
    );
  }
}
