import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/app_bar.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../providers/matches_provider.dart';
import '../widgets/match_card.dart';
import 'match_detail_screen.dart';
import 'live_match_screen.dart';

class MatchesScreen extends ConsumerWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: const AmedAppBar(
          title: 'Maçlar',
          bottom: TabBar(
            tabs: [
              Tab(text: 'Yaklaşan'),
              Tab(text: 'Geçmiş'),
              Tab(text: 'Canlı'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _UpcomingMatchesView(),
            _PastMatchesView(),
            _LiveMatchesView(),
          ],
        ),
      ),
    );
  }
}

class _UpcomingMatchesView extends ConsumerWidget {
  const _UpcomingMatchesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final upcoming = ref.watch(upcomingMatchesProvider);
    return upcoming.when(
      data: (matches) => RefreshIndicator(
        onRefresh: () => ref.refresh(upcomingMatchesProvider.future),
        child: ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return MatchCard(
              match: match,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => MatchDetailScreen(match: match)),
              ),
            );
          },
        ),
      ),
      loading: LoadingIndicator.new,
      error: (error, stackTrace) => _ErrorState(
        message: error.toString(),
        onRetry: () => ref.refresh(upcomingMatchesProvider.future),
      ),
    );
  }
}

class _PastMatchesView extends ConsumerStatefulWidget {
  const _PastMatchesView();

  @override
  ConsumerState<_PastMatchesView> createState() => _PastMatchesViewState();
}

class _PastMatchesViewState extends ConsumerState<_PastMatchesView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final notifier = ref.read(pastMatchesProvider.notifier);
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        notifier.hasMore) {
      notifier.loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pastMatches = ref.watch(pastMatchesProvider);
    return pastMatches.when(
      data: (matches) => RefreshIndicator(
        onRefresh: () => ref.read(pastMatchesProvider.notifier).refresh(),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return MatchCard(
              match: match,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => MatchDetailScreen(match: match)),
              ),
            );
          },
        ),
      ),
      loading: LoadingIndicator.new,
      error: (error, stackTrace) => _ErrorState(
        message: error.toString(),
        onRetry: () => ref.read(pastMatchesProvider.notifier).loadInitial(),
      ),
    );
  }
}

class _LiveMatchesView extends ConsumerWidget {
  const _LiveMatchesView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final liveMatches = ref.watch(liveMatchesProvider);
    return liveMatches.when(
      data: (matches) {
        if (matches.isEmpty) {
          return const _EmptyState(message: 'Şu anda canlı maç bulunmuyor.');
        }
        return ListView.builder(
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            return MatchCard(
              match: match,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => LiveMatchScreen(match: match)),
              ),
            );
          },
        );
      },
      loading: LoadingIndicator.new,
      error: (error, stackTrace) => _ErrorState(
        message: error.toString(),
        onRetry: () => ref.refresh(liveMatchesProvider.future),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            ElevatedButton(onPressed: onRetry, child: const Text('Tekrar Dene')),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
