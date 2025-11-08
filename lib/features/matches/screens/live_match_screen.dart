import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/models/match_model.dart';
import '../../../core/services/providers.dart';
import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../widgets/live_score_widget.dart';

class LiveMatchScreen extends ConsumerStatefulWidget {
  const LiveMatchScreen({super.key, required this.match});

  final Match match;

  @override
  ConsumerState<LiveMatchScreen> createState() => _LiveMatchScreenState();
}

class _LiveMatchScreenState extends ConsumerState<LiveMatchScreen> {
  late Timer _timer;
  late Match _currentMatch;

  @override
  void initState() {
    super.initState();
    _currentMatch = widget.match;
    _timer = Timer.periodic(
      AppConstants.liveRefreshInterval,
      (_) => _refreshLiveData(),
    );
    _refreshLiveData();
  }

  Future<void> _refreshLiveData() async {
    final api = ref.read(apiServiceProvider);
    final liveMatches = await api.fetchLiveMatches();
    final updated = liveMatches.firstWhere(
      (match) => match.id == _currentMatch.id,
      orElse: () => _currentMatch,
    );
    setState(() {
      _currentMatch = updated;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AmedAppBar(title: '${_currentMatch.homeTeam} vs ${_currentMatch.awayTeam}'),
      body: RefreshIndicator(
        onRefresh: _refreshLiveData,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            LiveScoreWidget(match: _currentMatch),
            _EventsSection(events: _currentMatch.events),
            _StatisticsSection(statistics: _currentMatch.statistics),
          ],
        ),
      ),
    );
  }
}

class _EventsSection extends StatelessWidget {
  const _EventsSection({required this.events});

  final List<MatchEvent> events;

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: LoadingIndicator(),
      );
    }
    return Card(
      margin: const EdgeInsets.all(16),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            leading: Text('${event.minute}\''),
            title: Text(event.player ?? ''),
            subtitle: Text(event.type),
            trailing: Text(event.team),
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemCount: events.length,
      ),
    );
  }
}

class _StatisticsSection extends StatelessWidget {
  const _StatisticsSection({required this.statistics});

  final MatchStatistics? statistics;

  @override
  Widget build(BuildContext context) {
    if (statistics == null) {
      return const SizedBox.shrink();
    }
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Canlı İstatistikler', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            _StatisticRow(label: 'Topla Oynama', value: '${statistics!.possession}%'),
            _StatisticRow(label: 'İsabetli Şut', value: '${statistics!.shotsOnTarget}'),
            _StatisticRow(label: 'Toplam Şut', value: '${statistics!.totalShots}'),
            _StatisticRow(label: 'Korner', value: '${statistics!.corners}'),
            _StatisticRow(label: 'Faul', value: '${statistics!.fouls}'),
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
