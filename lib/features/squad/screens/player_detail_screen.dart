import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/models/player_model.dart';
import '../../../shared/widgets/app_bar.dart';

class PlayerDetailScreen extends StatelessWidget {
  const PlayerDetailScreen({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AmedAppBar(title: player.name),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 64,
              backgroundImage:
                  player.photoUrl != null ? CachedNetworkImageProvider(player.photoUrl!) : null,
              child: player.photoUrl == null
                  ? Text(
                      player.number.toString(),
                      style: Theme.of(context).textTheme.headlineMedium,
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              player.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${player.position} | ${player.nationality} | ${player.age} yaş'),
            const SizedBox(height: 24),
            _StatisticTile(label: 'Oynadığı Maç', value: player.statistics.matchesPlayed.toString()),
            _StatisticTile(label: 'Gol', value: player.statistics.goals.toString()),
            _StatisticTile(label: 'Asist', value: player.statistics.assists.toString()),
            _StatisticTile(label: 'Sarı Kart', value: player.statistics.yellowCards.toString()),
            _StatisticTile(label: 'Kırmızı Kart', value: player.statistics.redCards.toString()),
            _StatisticTile(label: 'Ortalama Puan', value: player.statistics.averageRating.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }
}

class _StatisticTile extends StatelessWidget {
  const _StatisticTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(label),
        trailing: Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
