import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/models/player_model.dart';
import '../screens/player_detail_screen.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard({super.key, required this.player});

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: player.photoUrl.isNotEmpty
              ? CachedNetworkImageProvider(player.photoUrl)
              : null,
          child: player.photoUrl.isEmpty ? Text(player.number.toString()) : null,
        ),
        title: Text(player.name),
        subtitle: Text('${player.position} • #${player.number}'),
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => PlayerDetailScreen(player: player),
          ),
        ),
      ),
    );
  }
}
