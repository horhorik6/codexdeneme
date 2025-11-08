import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../squad/providers/squad_provider.dart';
import '../providers/statistics_provider.dart';
import '../widgets/form_chart.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(teamStatisticsProvider);
    final squad = ref.watch(squadProvider);

    return Scaffold(
      appBar: const AmedAppBar(title: 'İstatistikler'),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.wait([
            ref.refresh(teamStatisticsProvider.future),
            ref.refresh(squadProvider.future),
          ]);
        },
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            stats.when(
              data: (data) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Son 5 Maç Formu', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 12),
                    FormChart(form: data.form),
                    const SizedBox(height: 24),
                    _StatisticRow(label: 'Oynanan Maç', value: data.matchesPlayed.toString()),
                    _StatisticRow(label: 'Galibiyet', value: data.wins.toString()),
                    _StatisticRow(label: 'Beraberlik', value: data.draws.toString()),
                    _StatisticRow(label: 'Mağlubiyet', value: data.losses.toString()),
                    _StatisticRow(label: 'Toplam Gol', value: data.goalsFor.toString()),
                    _StatisticRow(label: 'Yenilen Gol', value: data.goalsAgainst.toString()),
                    _StatisticRow(label: 'Toplam Puan', value: data.points.toString()),
                  ],
                ),
              ),
              loading: LoadingIndicator.new,
              error: (error, stackTrace) => _ErrorState(message: error.toString()),
            ),
            const SizedBox(height: 24),
            squad.when(
              data: (players) {
                final sortedGoals = [...players]
                  ..sort((a, b) => b.statistics.goals.compareTo(a.statistics.goals));
                final sortedCards = [...players]
                  ..sort((a, b) => b.statistics.yellowCards.compareTo(a.statistics.yellowCards));
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Gol Krallığı', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      for (final player in sortedGoals.take(5))
                        ListTile(
                          leading: CircleAvatar(child: Text(player.number.toString())),
                          title: Text(player.name),
                          trailing: Text('${player.statistics.goals}'),
                        ),
                      const SizedBox(height: 16),
                      Text('Kart İstatistikleri', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 8),
                      for (final player in sortedCards.take(5))
                        ListTile(
                          leading: CircleAvatar(child: Text(player.number.toString())),
                          title: Text(player.name),
                          subtitle: Text('Kırmızı: ${player.statistics.redCards}'),
                          trailing: Text('Sarı: ${player.statistics.yellowCards}'),
                        ),
                    ],
                  ),
                );
              },
              loading: LoadingIndicator.new,
              error: (error, stackTrace) => _ErrorState(message: error.toString()),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatisticRow extends StatelessWidget {
  const _StatisticRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Text('Lütfen daha sonra tekrar deneyin.'),
        ],
      ),
    );
  }
}
