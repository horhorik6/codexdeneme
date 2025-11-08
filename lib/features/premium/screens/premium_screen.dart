import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/premium_model.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../providers/premium_provider.dart';
import '../widgets/premium_banner.dart';
import '../widgets/premium_content_card.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumState = ref.watch(premiumStateProvider);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D1F1A), Color(0xFF022B16), Color(0xFF0B4D2D)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: premiumState.when(
            data: (state) => _PremiumView(state: state),
            loading: LoadingIndicator.new,
            error: (error, stackTrace) => _PremiumError(error: error),
          ),
        ),
      ),
    );
  }
}

class _PremiumView extends StatelessWidget {
  const _PremiumView({required this.state});

  final PremiumState state;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          pinned: true,
          centerTitle: true,
          title: Text(
            state.isSubscribed ? 'Amedspor Premium' : 'Amedspor Premium+ kilidini aç',
            style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PremiumBanner(isSubscribed: state.isSubscribed),
                const SizedBox(height: 24),
                Text(
                  'Avantajlar',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: state.perks
                      .map(
                        (perk) => Chip(
                          label: Text(perk),
                          backgroundColor: Colors.white.withOpacity(0.1),
                          labelStyle: theme.textTheme.bodyMedium?.copyWith(color: Colors.white),
                          side: BorderSide(color: Colors.white.withOpacity(0.2)),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 32),
                Text(
                  'Özel İçerikler',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                if (state.exclusives.isEmpty)
                  Text(
                    'Supabase bağlanınca tüm özel içerikler otomatik yüklenecek.',
                    style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  )
                else
                  ...state.exclusives
                      .map((content) => PremiumContentCard(content: content, isLocked: !state.isSubscribed)),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PremiumError extends ConsumerWidget {
  const _PremiumError({required this.error});

  final Object error;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lock, color: Colors.white54, size: 64),
          const SizedBox(height: 12),
          Text(
            'Premium içeriği yüklerken bir sorun oluştu',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () => ref.read(premiumStateProvider.notifier).refresh(),
            child: const Text('Tekrar dene'),
          ),
        ],
      ),
    );
  }
}
