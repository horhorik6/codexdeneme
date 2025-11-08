import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/match_model.dart';
import '../../../core/models/news_model.dart';
import '../../../core/models/statistics_model.dart';
import '../../../shared/widgets/loading_indicator.dart';
import '../../matches/screens/match_detail_screen.dart';
import '../../matches/screens/matches_screen.dart';
import '../../matches/widgets/match_card.dart';
import '../../news/screens/news_screen.dart';
import '../../squad/screens/squad_screen.dart';
import '../../statistics/screens/statistics_screen.dart';
import '../../statistics/widgets/form_chart.dart';
import '../../premium/providers/premium_provider.dart';
import '../../premium/screens/premium_screen.dart';
import '../../premium/widgets/premium_banner.dart';
import '../providers/home_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> refreshAll() async {
      await Future.wait([
        ref.refresh(lastMatchProvider.future),
        ref.refresh(nextMatchProvider.future),
        ref.refresh(homeStatisticsProvider.future),
        ref.refresh(homeNewsProvider.future),
        ref.refresh(homeHighlightsProvider.future),
        ref.refresh(premiumStateProvider.future),
      ]);
    }

    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: RefreshIndicator(
        onRefresh: refreshAll,
        color: theme.colorScheme.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 280,
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              flexibleSpace: const FlexibleSpaceBar(
                background: _HomeHero(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    const _MatchesSection(),
                    const SizedBox(height: 24),
                    const _FormSection(),
                    const SizedBox(height: 24),
                    const _PremiumSection(),
                    const SizedBox(height: 24),
                    const _QuickActions(),
                    const SizedBox(height: 24),
                    const _HighlightsSection(),
                    const SizedBox(height: 24),
                    _NewsPreview(provider: homeNewsProvider),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeHero extends ConsumerWidget {
  const _HomeHero();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final lastMatch = ref.watch(lastMatchProvider);
    final nextMatch = ref.watch(nextMatchProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF04210F), Color(0xFF0B5B31), Color(0xFF0C7F45)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.only(top: 64, left: 20, right: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amedspor Evreni',
            style: theme.textTheme.headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Canlı skorlar, Supabase destekli veri akışları ve premium deneyim tek ekranda.',
            style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white70),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _HeroMatchCard(
                  title: 'Son Maç',
                  provider: lastMatch,
                  emptyMessage: 'Henüz maç bilgisi yok',
                  onTap: (match) => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MatchDetailScreen(match: match),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _HeroMatchCard(
                  title: 'Sıradaki Maç',
                  provider: nextMatch,
                  emptyMessage: 'Yaklaşan maç bulunamadı',
                  onTap: (match) {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _HeroMatchCard extends StatelessWidget {
  const _HeroMatchCard({
    required this.title,
    required this.provider,
    required this.emptyMessage,
    required this.onTap,
  });

  final String title;
  final AsyncValue<Match?> provider;
  final String emptyMessage;
  final ValueChanged<Match> onTap;

  @override
  Widget build(BuildContext context) {
    return provider.when(
      data: (match) {
        if (match == null) {
          return _HeroEmpty(title: title, message: emptyMessage);
        }
        return GestureDetector(
          onTap: () => onTap(match),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white.withOpacity(0.1),
              border: Border.all(color: Colors.white24),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white70)),
                const SizedBox(height: 8),
                Text(
                  '${match.homeTeam} vs ${match.awayTeam}',
                  style:
                      Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  match.dateFormatted,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  match.venue,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white54),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const LoadingIndicator(color: Colors.white),
      error: (error, stackTrace) => _HeroEmpty(title: title, message: emptyMessage),
    );
  }
}

class _HeroEmpty extends StatelessWidget {
  const _HeroEmpty({required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54),
          ),
        ],
      ),
    );
  }
}

class _MatchesSection extends ConsumerWidget {
  const _MatchesSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pastMatches = ref.watch(lastMatchProvider);
    final upcomingMatches = ref.watch(nextMatchProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionTitle(
          title: 'Maç Merkezine Göz At',
          onSeeAll: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MatchesScreen()),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 260,
          child: PageView(
            controller: PageController(viewportFraction: 0.9),
            children: [
              _MatchPreviewCard(provider: upcomingMatches),
              _MatchPreviewCard(provider: pastMatches),
            ],
          ),
        ),
      ],
    );
  }
}

class _MatchPreviewCard extends ConsumerWidget {
  const _MatchPreviewCard({required this.provider});

  final AsyncValue<Match?> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return provider.when(
      data: (match) {
        if (match == null) {
          return const _EmptyPlaceholder(message: 'Maç bilgisi bulunamadı.');
        }
        return MatchCard(match: match);
      },
      loading: LoadingIndicator.new,
      error: (error, stackTrace) => _ErrorPlaceholder(message: error.toString()),
    );
  }
}

class _FormSection extends ConsumerWidget {
  const _FormSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(homeStatisticsProvider);
    return stats.when(
      data: (TeamStatistics data) {
        if (data.form.isEmpty) {
          return const _EmptyPlaceholder(message: 'Form bilgisi bulunamadı.');
        }
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SectionTitle(
                title: 'Form Grafiği',
                onSeeAll: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const StatisticsScreen()),
                ),
              ),
              const SizedBox(height: 16),
              FormChart(form: data.form),
            ],
          ),
        );
      },
      loading: LoadingIndicator.new,
      error: (error, stackTrace) => _ErrorPlaceholder(message: error.toString()),
    );
  }
}

class _PremiumSection extends ConsumerWidget {
  const _PremiumSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final premiumState = ref.watch(premiumStateProvider);

    return premiumState.when(
      data: (state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(
              title: 'Premium+ Deneyimini Keşfet',
              onSeeAll: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PremiumScreen()),
              ),
            ),
            const SizedBox(height: 12),
            PremiumBanner(isSubscribed: state.isSubscribed),
            const SizedBox(height: 12),
            if (state.exclusives.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Önizleme',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.exclusives.first.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.exclusives.first.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const PremiumScreen()),
                      ),
                      icon: const Icon(Icons.play_arrow),
                      label: Text(state.isSubscribed ? 'İçeriği aç' : 'Premium\'u dene'),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
      loading: LoadingIndicator.new,
      error: (error, stackTrace) => _ErrorPlaceholder(message: error.toString()),
    );
  }
}

class _HighlightsSection extends ConsumerWidget {
  const _HighlightsSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final highlights = ref.watch(homeHighlightsProvider);
    return highlights.when(
      data: (videos) {
        if (videos.isEmpty) {
          return const _EmptyPlaceholder(message: 'Video özeti bulunamadı.');
        }
        final displayCount = videos.length > 5 ? 5 : videos.length;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SectionTitle(
              title: 'Maç Özetleri',
              onSeeAll: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NewsScreen()),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: displayCount,
                separatorBuilder: (_, __) => const SizedBox(width: 16),
                itemBuilder: (context, index) {
                  final video = videos[index];
                  return _HighlightCard(article: video);
                },
              ),
            ),
          ],
        );
      },
      loading: LoadingIndicator.new,
      error: (error, stackTrace) => _ErrorPlaceholder(message: error.toString()),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const NewsScreen()),
      ),
      child: Container(
        width: 240,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [Color(0xFF0F2C1D), Color(0xFF0C5A36)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                'Özet',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const Spacer(),
            Text(
              article.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              article.publishedAtFormatted,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions();

  @override
  Widget build(BuildContext context) {
    final buttonStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(140, 52),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
    );

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        _QuickActionButton(
          label: 'Maçlar',
          icon: Icons.sports_soccer,
          style: buttonStyle,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const MatchesScreen()),
          ),
        ),
        _QuickActionButton(
          label: 'Kadro',
          icon: Icons.group,
          style: buttonStyle,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const SquadScreen()),
          ),
        ),
        _QuickActionButton(
          label: 'İstatistik',
          icon: Icons.bar_chart,
          style: buttonStyle,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const StatisticsScreen()),
          ),
        ),
        _QuickActionButton(
          label: 'Haberler',
          icon: Icons.article,
          style: buttonStyle,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const NewsScreen()),
          ),
        ),
        _QuickActionButton(
          label: 'Premium',
          icon: Icons.workspace_premium,
          style: buttonStyle,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const PremiumScreen()),
          ),
        ),
      ],
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.style,
  });

  final String label;
  final IconData icon;
  final VoidCallback onPressed;
  final ButtonStyle style;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: style,
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(label),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        if (onSeeAll != null)
          TextButton(
            onPressed: onSeeAll,
            child: const Text('Tümünü Gör'),
          ),
      ],
    );
  }
}

class _NewsPreview extends ConsumerWidget {
  const _NewsPreview({required this.provider});

  final FutureProvider<List<NewsArticle>> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(provider);
    return data.when(
      data: (news) {
        if (news.isEmpty) {
          return const _EmptyPlaceholder(message: 'Haber bulunamadı.');
        }
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            children: [
              _SectionTitle(
                title: 'Güncel Haberler',
                onSeeAll: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const NewsScreen()),
                ),
              ),
              const SizedBox(height: 12),
              ...news.take(3).map(
                (article) => _NewsListTile(article: article),
              ),
            ],
          ),
        );
      },
      loading: LoadingIndicator.new,
      error: (error, stackTrace) => _ErrorPlaceholder(message: error.toString()),
    );
  }
}

class _NewsListTile extends StatelessWidget {
  const _NewsListTile({required this.article});

  final NewsArticle article;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: const Icon(Icons.article, color: Colors.white),
      ),
      title: Text(article.title),
      subtitle: Text(article.summary, maxLines: 2, overflow: TextOverflow.ellipsis),
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const NewsScreen()),
      ),
    );
  }
}

class _EmptyPlaceholder extends StatelessWidget {
  const _EmptyPlaceholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(message, textAlign: TextAlign.center),
    );
  }
}

class _ErrorPlaceholder extends StatelessWidget {
  const _ErrorPlaceholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 8),
          const Text('Lütfen daha sonra tekrar deneyin.', textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
