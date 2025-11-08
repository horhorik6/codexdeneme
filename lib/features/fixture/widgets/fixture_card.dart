import 'package:flutter/material.dart';

import '../../../core/models/match_model.dart';
import '../../../core/utils/date_formatter.dart';

class FixtureCard extends StatelessWidget {
  const FixtureCard({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('${match.homeTeam} vs ${match.awayTeam}'),
        subtitle: Text(DateFormatter.formatDateTime(match.date)),
        trailing: IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () {},
        ),
      ),
    );
  }
}
