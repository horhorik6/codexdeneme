import 'package:flutter/material.dart';

import '../../../core/models/match_model.dart';
import '../../../core/utils/date_formatter.dart';
import '../widgets/live_score_widget.dart';

class MatchDetailScreen extends StatelessWidget {
  const MatchDetailScreen({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Maç Detayı')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          LiveScoreWidget(match: match),
          const SizedBox(height: 16),
          Text(
            'Stadyum: ${match.venue}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Tarih: ${DateFormatter.formatDateTime(match.date)}',
          ),
          const SizedBox(height: 16),
          Text(
            'Maç Olayları',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (match.events.isEmpty)
            const Text('Henüz olay bulunmuyor.')
          else
            ...match.events.map(
              (event) => ListTile(
                leading: Text('${event.minute}\''),
                title: Text('${event.type} - ${event.player}'),
                subtitle: Text(event.detail ?? ''),
              ),
            ),
        ],
      ),
    );
  }
}
