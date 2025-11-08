import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../providers/fixture_provider.dart';
import '../widgets/fixture_card.dart';

class FixtureScreen extends ConsumerStatefulWidget {
  const FixtureScreen({super.key});

  @override
  ConsumerState<FixtureScreen> createState() => _FixtureScreenState();
}

class _FixtureScreenState extends ConsumerState<FixtureScreen> {
  bool _showHome = true;
  bool _showAway = true;

  @override
  Widget build(BuildContext context) {
    final fixtures = ref.watch(fixtureProvider);

    return Scaffold(
      appBar: const AmedAppBar(title: 'Sezon Fikstürü'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Wrap(
              spacing: 8,
              children: [
                FilterChip(
                  label: const Text('İç Saha'),
                  selected: _showHome,
                  onSelected: (value) => setState(() => _showHome = value),
                ),
                FilterChip(
                  label: const Text('Deplasman'),
                  selected: _showAway,
                  onSelected: (value) => setState(() => _showAway = value),
                ),
              ],
            ),
          ),
          Expanded(
            child: fixtures.when(
              data: (matches) {
                final filtered = matches.where((match) {
                  final isHome = match.homeTeam.toLowerCase().contains('amed');
                  if (isHome && !_showHome) return false;
                  if (!isHome && !_showAway) return false;
                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text('Maç bulunamadı.')); 
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref.refresh(fixtureProvider.future);
                  },
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final match = filtered[index];
                      return FixtureCard(
                        match: match,
                        onAddToCalendar: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Takvime ekleme özelliği yakında.')),
                          );
                        },
                      );
                    },
                  ),
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
}
