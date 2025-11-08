import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/match_model.dart';
import '../../../core/models/premium_model.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../premium/providers/premium_provider.dart';
import '../../premium/screens/premium_screen.dart';

class MatchDetailScreen extends ConsumerWidget {
  const MatchDetailScreen({super.key, required this.match});

  final Match match;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumState = ref.watch(premiumStateProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              title: Text('${match.homeTeam} - ${match.awayTeam}'),
              background: _MatchHero(match: match),
            ),
          ),
          SliverToBoxAdapter(child: _ScoreSummary(match: match)),
          SliverToBoxAdapter(child: _StatisticsSection(match: match)),
          SliverToBoxAdapter(
            child: _PremiumAnalyticsSection(match: match, premiumState: premiumState),
          ),
          SliverToBoxAdapter(child: _EventsSection(events: match.events)),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _MatchHero extends StatelessWidget {
  const _MatchHero({required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF041F12), Color(0xFF0A4F30), Color(0xFF127A4A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Chip(
            backgroundColor: Colors.white.withOpacity(0.2),
            label: Text(
              match.status.toUpperCase(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const Spacer(),
          Text(
            match.venue,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            '${match.homeTeam} vs ${match.awayTeam}',
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(
            match.dateFormatted,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _ScoreSummary extends StatelessWidget {
  const _ScoreSummary({required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(
              '${match.homeScore ?? '-'} : ${match.awayScore ?? '-'}',
              style:
                  Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${match.homeTeam} - ${match.awayTeam}', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }
}

class _StatisticsSection extends StatelessWidget {
  const _StatisticsSection({required this.match});

  final Match match;

  @override
  Widget build(BuildContext context) {
    final statistics = match.statistics;
    if (statistics == null) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Maç İstatistikleri', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            _StatisticRow(label: 'Topla Oynama', value: '${statistics.possession}%'),
            _StatisticRow(label: 'İsabetli Şut', value: statistics.shotsOnTarget.toString()),
            _StatisticRow(label: 'Toplam Şut', value: statistics.totalShots.toString()),
            _StatisticRow(label: 'Korner', value: statistics.corners.toString()),
            _StatisticRow(label: 'Faul', value: statistics.fouls.toString()),
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
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _PremiumAnalyticsSection extends StatelessWidget {
  const _PremiumAnalyticsSection({required this.match, required this.premiumState});

  final Match match;
  final AsyncValue<PremiumState> premiumState;

  @override
  Widget build(BuildContext context) {
    return premiumState.when(
      data: (PremiumState state) {
        final isSubscribed = state.isSubscribed;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF0E6838),
                  const Color(0xFF054726),
                  Colors.black.withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      isSubscribed ? Icons.auto_graph : Icons.lock_outline,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Premium Taktik Analizi',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  isSubscribed
                      ? 'xG, pas haritaları ve Supabase canlı içgörüleri ile ${match.homeTeam} - ${match.awayTeam} mücadelesinin derin analizi.'
                      : 'Supabase destekli canlı taktik içgörüler, xG trendleri ve oyuncu ısı haritaları Premium+ üyelerine açıktır.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 16),
                if (!isSubscribed)
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const PremiumScreen()),
                    ),
                    child: const Text('Premium+ ile kilidi aç'),
                  )
                else
                  const _PremiumMetrics(),
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingIndicator(),
      error: (error, stackTrace) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Text('Premium içeriği yüklenemedi: $error'),
      ),
    );
  }
}

class _PremiumMetrics extends StatelessWidget {
  const _PremiumMetrics();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MetricRow(label: 'Tahmini xG', homeValue: '1.62', awayValue: '1.04'),
        _MetricRow(label: 'Pres yoğunluğu', homeValue: '63%', awayValue: '51%'),
        _MetricRow(label: 'Anahtar paslar', homeValue: '14', awayValue: '9'),
      ],
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({required this.label, required this.homeValue, required this.awayValue});

  final String label;
  final String homeValue;
  final String awayValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70)),
          ),
          Text(homeValue, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
          const SizedBox(width: 16),
          Text(awayValue, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}

class _EventsSection extends StatelessWidget {
  const _EventsSection({required this.events});

  final List<MatchEvent> events;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: Theme.of(context).colorScheme.surface,
        ),
        child: events.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: LoadingIndicator(),
              )
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final event = events[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        event.minute.toString(),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(event.player ?? ''),
                    subtitle: Text(event.type),
                    trailing: Text(event.team),
                  );
                },
              ),
      ),
    );
  }
}
