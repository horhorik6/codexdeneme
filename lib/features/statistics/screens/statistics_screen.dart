import 'package:flutter/material.dart';

import '../../../core/models/statistics_model.dart';
import '../widgets/form_chart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  final TeamStatistics teamStatistics = const TeamStatistics(
    played: 0,
    wins: 0,
    draws: 0,
    losses: 0,
    goalsFor: 0,
    goalsAgainst: 0,
    cleanSheets: 0,
    averageGoalsPerMatch: 0,
  );

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Form Grafiği', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        FormChart(matches: const []),
        const SizedBox(height: 24),
        _buildStatisticsCard(context),
      ],
    );
  }

  Widget _buildStatisticsCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Takım İstatistikleri',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            _buildStatRow('Oynanan Maç', teamStatistics.played.toString()),
            _buildStatRow('Galibiyet', teamStatistics.wins.toString()),
            _buildStatRow('Beraberlik', teamStatistics.draws.toString()),
            _buildStatRow('Mağlubiyet', teamStatistics.losses.toString()),
            _buildStatRow('Atılan Gol', teamStatistics.goalsFor.toString()),
            _buildStatRow('Yenilen Gol', teamStatistics.goalsAgainst.toString()),
            _buildStatRow('Gol Ortalaması',
                teamStatistics.averageGoalsPerMatch.toStringAsFixed(2)),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
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
