import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/models/premium_model.dart';
import '../../../core/services/providers.dart';

final premiumStateProvider =
    AutoDisposeAsyncNotifierProvider<PremiumNotifier, PremiumState>(
  PremiumNotifier.new,
);

class PremiumNotifier extends AutoDisposeAsyncNotifier<PremiumState> {
  static const _deviceId = 'demo-device';

  @override
  Future<PremiumState> build() async {
    final supabase = ref.watch(supabaseServiceProvider);
    final baseState = PremiumState.initial();

    final isPremium = await supabase.isUserPremium(deviceId: _deviceId);
    final content = await supabase.fetchPremiumContent();
    final featuredVideo = await supabase.fetchFeaturedVideoId();

    return baseState.copyWith(
      isSubscribed: isPremium,
      exclusives: content,
      featuredVideo: featuredVideo,
    );
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await build());
  }

  Future<void> unlockPreview() async {
    final current = await future;
    state = AsyncValue.data(current.copyWith(isSubscribed: true));
  }
}
