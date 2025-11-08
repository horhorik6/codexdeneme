class AppConstants {
  AppConstants._();

  static const appName = 'Amedspor';
  static const cacheBoxName = 'amedspor_cache_box';
  static const matchesCollection = 'matches';
  static const playersCollection = 'players';
  static const newsCollection = 'news';
  static const statisticsCollection = 'statistics';

  static const liveRefreshInterval = Duration(seconds: 30);
  static const cacheExpiry = Duration(minutes: 15);
  static const maxRetryCount = 3;
}
