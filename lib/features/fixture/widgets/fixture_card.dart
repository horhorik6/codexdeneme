import 'package:flutter/material.dart';

import '../../../core/models/match_model.dart';
import '../../../core/utils/date_formatter.dart';

class FixtureCard extends StatelessWidget {
  const FixtureCard({
    super.key,
    required this.match,
    this.onAddToCalendar,
  });

  final Match match;
  final VoidCallback? onAddToCalendar;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormatter.formatMatchDate(match.date),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(match.homeTeam, style: Theme.of(context).textTheme.titleLarge)),
                Text('vs', style: Theme.of(context).textTheme.titleLarge),
                Expanded(
                  child: Text(
                    match.awayTeam,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(match.venue),
                ElevatedButton.icon(
                  onPressed: onAddToCalendar,
                  icon: const Icon(Icons.event),
                  label: const Text('Takvime Ekle'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
