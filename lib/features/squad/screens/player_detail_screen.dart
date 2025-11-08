import 'package:flutter/material.dart';

import '../../../core/models/player_model.dart';

class PlayerDetailScreen extends StatelessWidget {
  const PlayerDetailScreen({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(player.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Numara: ${player.number}'),
            Text('Pozisyon: ${player.position}'),
            Text('Yaş: ${player.age}'),
            Text('Uyruk: ${player.nationality}'),
            const SizedBox(height: 16),
            Text(
              'İstatistikler',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Maç: ${player.statistics.matchesPlayed}'),
            Text('Gol: ${player.statistics.goals}'),
            Text('Asist: ${player.statistics.assists}'),
            Text('Sarı Kart: ${player.statistics.yellowCards}'),
            Text('Kırmızı Kart: ${player.statistics.redCards}'),
          ],
        ),
      ),
    );
  }
}
