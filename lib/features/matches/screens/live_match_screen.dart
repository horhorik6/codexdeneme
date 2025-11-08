import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../providers/matches_provider.dart';
import '../widgets/live_score_widget.dart';

class LiveMatchScreen extends ConsumerWidget {
  const LiveMatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final matchesState = ref.watch(matchesProvider);

    return matchesState.when(
      data: (matches) {
        final liveMatches = matches.where((match) => match.isLive).toList();
        if (liveMatches.isEmpty) {
          return const Center(child: Text('Şu anda canlı maç bulunmuyor.'));
        }
        return RefreshIndicator(
          onRefresh: () => ref.read(matchesProvider.notifier).refreshLiveMatches(),
          child: ListView.separated(
            itemCount: liveMatches.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) => LiveScoreWidget(match: liveMatches[index]),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(
        child: Text('Hata: ${error.toString()}'),
      ),
    );
  }
}

class LiveRefreshIndicator extends StatelessWidget {
  const LiveRefreshIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text('Canlı veriler her ${AppConstants.liveRefreshInterval.inSeconds} saniyede yenilenir.'),
    );
  }
}
