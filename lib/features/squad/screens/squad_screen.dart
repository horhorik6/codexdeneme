import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../../core/models/player_model.dart';
import '../providers/squad_provider.dart';
import '../widgets/player_card.dart';
import 'player_detail_screen.dart';

class SquadScreen extends ConsumerStatefulWidget {
  const SquadScreen({super.key});

  @override
  ConsumerState<SquadScreen> createState() => _SquadScreenState();
}

class _SquadScreenState extends ConsumerState<SquadScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final squad = ref.watch(squadProvider);
    return Scaffold(
      appBar: const AmedAppBar(title: 'Amedspor Kadrosu'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Oyuncu ara',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: squad.when(
              data: (players) {
                final filtered = players.where((player) {
                  if (_searchQuery.isEmpty) return true;
                  return player.name.toLowerCase().contains(_searchQuery) ||
                      player.position.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Oyuncu bulunamadı.'));
                }

                final grouped = _groupPlayers(filtered);
                return ListView(
                  children: grouped.entries
                      .map((entry) => _PositionSection(
                            position: entry.key,
                            players: entry.value,
                          ))
                      .toList(),
                );
              },
              loading: LoadingIndicator.new,
              error: (error, stackTrace) => Center(child: Text(error.toString())),
            ),
          ),
        ],
      ),
    );
  }

  Map<String, List<Player>> _groupPlayers(List<Player> players) {
    final Map<String, List<Player>> grouped = {
      'Kaleciler': [],
      'Defans': [],
      'Orta Saha': [],
      'Forvet': [],
      'Diğer': [],
    };

    for (final player in players) {
      final position = player.position.toLowerCase();
      if (position.contains('kaleci')) {
        grouped['Kaleciler']!.add(player);
      } else if (position.contains('defans')) {
        grouped['Defans']!.add(player);
      } else if (position.contains('orta')) {
        grouped['Orta Saha']!.add(player);
      } else if (position.contains('forvet') || position.contains('hüc')) {
        grouped['Forvet']!.add(player);
      } else {
        grouped['Diğer']!.add(player);
      }
    }
    grouped.removeWhere((key, value) => value.isEmpty);
    return grouped;
  }
}

class _PositionSection extends StatelessWidget {
  const _PositionSection({required this.position, required this.players});

  final String position;
  final List<Player> players;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            position,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        for (final player in players)
          PlayerCard(
            player: player,
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => PlayerDetailScreen(player: player),
              ),
            ),
          ),
      ],
    );
  }
}
