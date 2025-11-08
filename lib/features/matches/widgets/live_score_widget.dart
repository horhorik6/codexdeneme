import 'package:flutter/material.dart';

import '../../../core/models/match_model.dart';

class LiveScoreWidget extends StatelessWidget {
  const LiveScoreWidget({
    super.key,
    required this.match,
  });

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'CANLI',
              style: Theme.of(context)
                  .textTheme
                  .labelLarge
                  ?.copyWith(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    match.homeTeam,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Column(
                  children: [
                    Text(
                      '${match.homeScore ?? '-'} : ${match.awayScore ?? '-'}',
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text('${match.events.where((event) => event.type == 'Goal').length} gol'),
                  ],
                ),
                Expanded(
                  child: Text(
                    match.awayTeam,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Statü: ${match.status}'),
          ],
        ),
      ),
    );
  }
}
