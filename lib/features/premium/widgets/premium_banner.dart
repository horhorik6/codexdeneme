import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/premium_provider.dart';

class PremiumBanner extends ConsumerWidget {
  const PremiumBanner({super.key, required this.isSubscribed});

  final bool isSubscribed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [Color(0xFF17C964), Color(0xFF0E7A3B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 24,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isSubscribed ? Icons.verified : Icons.stars,
                color: Colors.white,
                size: 34,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isSubscribed
                      ? 'Premium üyelik aktif!'
                      : 'Amedspor Premium+ ile güçlen',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            isSubscribed
                ? 'Canlı maç içi taktik bildirimleri ve gelişmiş istatistikler açıldı.'
                : 'Canlı maç içi taktik bildirimleri, Supabase destekli veri akışları ve özel video içerikleri seni bekliyor.',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.tonal(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF0D381F),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
              onPressed: isSubscribed
                  ? null
                  : () => ref.read(premiumStateProvider.notifier).unlockPreview(),
              child: Text(isSubscribed ? 'Aktif' : '3 gün ücretsiz dene'),
            ),
          ),
        ],
      ),
    );
  }
}
