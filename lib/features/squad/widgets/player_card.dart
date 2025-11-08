import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/models/player_model.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    super.key,
    required this.player,
    this.onTap,
  });

  final Player player;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundImage:
              player.photoUrl != null ? CachedNetworkImageProvider(player.photoUrl!) : null,
          child: player.photoUrl == null ? Text(player.number.toString()) : null,
        ),
        title: Text(player.name),
        subtitle: Text('${player.position} | No: ${player.number}'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Gol: ${player.statistics.goals}'),
            Text('Asist: ${player.statistics.assists}'),
          ],
        ),
      ),
    );
  }
}
