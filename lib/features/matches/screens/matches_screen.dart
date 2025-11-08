import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/match_model.dart';
import '../../../core/utils/error_handler.dart';
import '../providers/matches_provider.dart';
import '../widgets/live_score_widget.dart';
import '../widgets/match_card.dart';

class MatchesScreen extends ConsumerStatefulWidget {
  const MatchesScreen({super.key});

  @override
  ConsumerState<MatchesScreen> createState() => _MatchesScreenState();
}

class _MatchesScreenState extends ConsumerState<MatchesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final matchesState = ref.watch(matchesProvider);

    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).colorScheme.primary,
          tabs: const [
            Tab(text: 'Yaklaşan'),
            Tab(text: 'Geçmiş'),
            Tab(text: 'Canlı'),
          ],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildUpcoming(matchesState),
              _buildPast(matchesState),
              _buildLive(matchesState),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUpcoming(AsyncValue<List<Match>> state) {
    return state.when(
      data: (matches) => RefreshIndicator(
        onRefresh: () => ref.read(matchesProvider.notifier).loadMatches(),
        child: ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) => MatchCard(match: matches[index]),
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(ErrorHandler.getErrorMessage(error)),
      ),
    );
  }

  Widget _buildPast(AsyncValue<List<Match>> state) {
    return state.when(
      data: (matches) {
        final finishedMatches =
            matches.where((match) => match.isFinished).toList();
        if (finishedMatches.isEmpty) {
          return const Center(child: Text('Geçmiş maç bulunamadı.'));
        }
        return ListView.builder(
          itemCount: finishedMatches.length,
          itemBuilder: (context, index) => MatchCard(
            match: finishedMatches[index],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(ErrorHandler.getErrorMessage(error)),
      ),
    );
  }

  Widget _buildLive(AsyncValue<List<Match>> state) {
    return state.when(
      data: (matches) {
        final liveMatches = matches.where((match) => match.isLive).toList();
        if (liveMatches.isEmpty) {
          return const Center(child: Text('Canlı maç yok.'));
        }
        return ListView.builder(
          itemCount: liveMatches.length,
          itemBuilder: (context, index) => LiveScoreWidget(
            match: liveMatches[index],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text(ErrorHandler.getErrorMessage(error)),
      ),
    );
  }
}
