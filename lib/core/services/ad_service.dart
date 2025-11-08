import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  AdService._();

  static final AdService instance = AdService._();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    await MobileAds.instance.initialize();
    _initialized = true;
  }

  String get bannerAdUnitId => dotenv.env['ADMOB_BANNER_ID'] ?? '';

  String get interstitialAdUnitId => dotenv.env['ADMOB_INTERSTITIAL_ID'] ?? '';

  BannerAd createBannerAd({BannerAdListener? listener}) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: listener ?? const BannerAdListener(),
    );
  }

  InterstitialAdLoadCallback createInterstitialListener(void Function(InterstitialAd) onLoaded) {
    return InterstitialAdLoadCallback(
      onAdLoaded: onLoaded,
      onAdFailedToLoad: (LoadAdError error) {},
    );
  }
}
