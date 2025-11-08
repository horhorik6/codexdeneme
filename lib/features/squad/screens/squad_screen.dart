import 'package:flutter/material.dart';

import '../../../core/models/player_model.dart';
import '../widgets/player_card.dart';

class SquadScreen extends StatefulWidget {
  const SquadScreen({super.key});

  @override
  State<SquadScreen> createState() => _SquadScreenState();
}

class _SquadScreenState extends State<SquadScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<Player> _players = const [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredPlayers = _players
        .where(
          (player) => player.name
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()),
        )
        .toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Oyuncu ara',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
        Expanded(
          child: filteredPlayers.isEmpty
              ? const Center(child: Text('Oyuncu bulunamadı.'))
              : ListView.builder(
                  itemCount: filteredPlayers.length,
                  itemBuilder: (context, index) => PlayerCard(
                    player: filteredPlayers[index],
                  ),
                ),
        ),
      ],
    );
  }
}
