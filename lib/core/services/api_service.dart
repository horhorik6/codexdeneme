import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../models/match_model.dart';
import '../models/news_model.dart';
import '../models/player_model.dart';
import '../models/statistics_model.dart';
import '../utils/error_handler.dart';

class ApiService {
  ApiService({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options = BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    );
  }

  final Dio _dio;

  String get _apiFootballKey => dotenv.env['API_FOOTBALL_KEY'] ?? '';
  String get _apiFootballHost => dotenv.env['API_FOOTBALL_HOST'] ?? '';
  String get _footballDataKey => dotenv.env['FOOTBALL_DATA_KEY'] ?? '';
  String get _newsApiKey => dotenv.env['NEWS_API_KEY'] ?? '';
  String get _youtubeApiKey => dotenv.env['YOUTUBE_API_KEY'] ?? '';

  Future<List<Match>> fetchUpcomingMatches() async {
    return _requestWithRetry(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConstants.apiFootballBaseUrl}/fixtures',
        queryParameters: <String, dynamic>{
          'team': ApiConstants.amedsporTeamId,
          'season': DateTime.now().year,
          'status': 'NS',
          'next': 10,
        },
        options: Options(headers: _apiFootballHeaders),
      );

      final fixtures = response.data?['response'] as List<dynamic>? ?? [];
      return fixtures
          .map((dynamic fixture) => _parseFixture(fixture as Map<String, dynamic>))
          .toList();
    });
  }

  Future<List<Match>> fetchLiveMatches() async {
    return _requestWithRetry(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConstants.apiFootballBaseUrl}/fixtures',
        queryParameters: <String, dynamic>{
          'team': ApiConstants.amedsporTeamId,
          'season': DateTime.now().year,
          'live': 'all',
        },
        options: Options(headers: _apiFootballHeaders),
      );

      final fixtures = response.data?['response'] as List<dynamic>? ?? [];
      return fixtures
          .map((dynamic fixture) => _parseFixture(fixture as Map<String, dynamic>))
          .toList();
    });
  }

  Future<List<Match>> fetchPastMatches({int page = 1}) async {
    return _requestWithRetry(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConstants.apiFootballBaseUrl}/fixtures',
        queryParameters: <String, dynamic>{
          'team': ApiConstants.amedsporTeamId,
          'season': DateTime.now().year,
          'status': 'FT',
          'last': AppConstants.fixturePageSize,
          'page': page,
        },
        options: Options(headers: _apiFootballHeaders),
      );

      final fixtures = response.data?['response'] as List<dynamic>? ?? [];
      return fixtures
          .map((dynamic fixture) => _parseFixture(fixture as Map<String, dynamic>))
          .toList();
    });
  }

  Future<List<Match>> fetchSeasonFixtures() async {
    return _requestWithRetry(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConstants.apiFootballBaseUrl}/fixtures',
        queryParameters: <String, dynamic>{
          'team': ApiConstants.amedsporTeamId,
          'season': DateTime.now().year,
        },
        options: Options(headers: _apiFootballHeaders),
      );

      final fixtures = response.data?['response'] as List<dynamic>? ?? [];
      return fixtures
          .map((dynamic fixture) => _parseFixture(fixture as Map<String, dynamic>))
          .toList();
    });
  }

  Future<TeamStatistics> fetchTeamStatistics() async {
    return _requestWithRetry(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConstants.footballDataBaseUrl}/teams/${ApiConstants.amedsporTeamId}/matches',
        options: Options(headers: _footballDataHeaders),
      );

      final matches = response.data?['matches'] as List<dynamic>? ?? [];
      final form = matches.take(5).map<String>((dynamic match) {
        final map = match as Map<String, dynamic>;
        final score = map['score'] as Map<String, dynamic>?;
        final fullTime = score?['fullTime'] as Map<String, dynamic>?;
        final homeScore = fullTime?['home'] as int? ?? 0;
        final awayScore = fullTime?['away'] as int? ?? 0;
        final isHomeTeam = (map['homeTeam'] as Map<String, dynamic>?)?['id'] == ApiConstants.amedsporTeamId;
        final amedScore = isHomeTeam ? homeScore : awayScore;
        final opponentScore = isHomeTeam ? awayScore : homeScore;
        if (amedScore > opponentScore) return 'W';
        if (amedScore == opponentScore) return 'D';
        return 'L';
      }).toList();

      return TeamStatistics(
        form: form,
        goalsFor: 0,
        goalsAgainst: 0,
        points: 0,
        matchesPlayed: matches.length,
        wins: form.where((result) => result == 'W').length,
        draws: form.where((result) => result == 'D').length,
        losses: form.where((result) => result == 'L').length,
        cleanSheets: 0,
        yellowCards: 0,
        redCards: 0,
      );
    });
  }

  Future<List<Player>> fetchSquad() async {
    return _requestWithRetry(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConstants.apiFootballBaseUrl}/players',
        queryParameters: <String, dynamic>{
          'team': ApiConstants.amedsporTeamId,
          'season': DateTime.now().year,
        },
        options: Options(headers: _apiFootballHeaders),
      );

      final players = response.data?['response'] as List<dynamic>? ?? [];
      return players.map((dynamic player) {
        final playerMap = player as Map<String, dynamic>;
        final playerInfo = playerMap['player'] as Map<String, dynamic>? ?? {};
        final statistics = (playerMap['statistics'] as List<dynamic>? ?? []).firstOrNull
                as Map<String, dynamic>? ??
            {};
        final games = statistics['games'] as Map<String, dynamic>? ?? {};
        final goals = statistics['goals'] as Map<String, dynamic>? ?? {};
        final cards = statistics['cards'] as Map<String, dynamic>? ?? {};

        return Player(
          id: (playerInfo['id'] ?? '').toString(),
          name: playerInfo['name'] as String? ?? 'Bilinmiyor',
          number: playerInfo['number'] as int? ?? 0,
          position: games['position'] as String? ?? 'Bilinmiyor',
          age: playerInfo['age'] as int? ?? 0,
          nationality: playerInfo['nationality'] as String? ?? 'Türkiye',
          photoUrl: playerInfo['photo'] as String?,
          statistics: PlayerStatistics(
            matchesPlayed: games['appearences'] as int? ?? 0,
            goals: goals['total'] as int? ?? 0,
            assists: goals['assists'] as int? ?? 0,
            yellowCards: cards['yellow'] as int? ?? 0,
            redCards: cards['red'] as int? ?? 0,
            averageRating: double.tryParse(games['rating']?.toString() ?? '') ?? 0,
          ),
        );
      }).toList();
    });
  }

  Future<List<NewsArticle>> fetchNews({int page = 1}) async {
    return _requestWithRetry(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConstants.newsBaseUrl}/everything',
        queryParameters: <String, dynamic>{
          'q': ApiConstants.newsQuery,
          'language': 'tr',
          'page': page,
          'pageSize': AppConstants.newsPageSize,
          'sortBy': 'publishedAt',
        },
        options: Options(headers: _newsHeaders),
      );

      final articles = response.data?['articles'] as List<dynamic>? ?? [];
      return articles.map((dynamic article) {
        final map = article as Map<String, dynamic>;
        return NewsArticle(
          id: map['url'] as String,
          title: map['title'] as String? ?? 'Amedspor Haberi',
          summary: map['description'] as String? ?? '',
          url: map['url'] as String? ?? '',
          imageUrl: map['urlToImage'] as String? ?? '',
          publishedAt: DateTime.tryParse(map['publishedAt'] as String? ?? '') ?? DateTime.now(),
          source: (map['source'] as Map<String, dynamic>?)?['name'] as String?,
          videoUrl: null,
        );
      }).toList();
    });
  }

  Future<List<NewsArticle>> fetchYoutubeHighlights() async {
    return _requestWithRetry(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '${ApiConstants.youtubeBaseUrl}/search',
        queryParameters: <String, dynamic>{
          'part': 'snippet',
          'q': ApiConstants.youtubeQuery,
          'type': 'video',
          'maxResults': 10,
          'key': _youtubeApiKey,
        },
      );

      final items = response.data?['items'] as List<dynamic>? ?? [];
      return items.map((dynamic item) {
        final map = item as Map<String, dynamic>;
        final id = map['id'] as Map<String, dynamic>? ?? {};
        final snippet = map['snippet'] as Map<String, dynamic>? ?? {};
        final videoId = id['videoId'] as String? ?? '';
        return NewsArticle(
          id: videoId,
          title: snippet['title'] as String? ?? 'Amedspor Özet',
          summary: snippet['description'] as String? ?? '',
          url: 'https://www.youtube.com/watch?v=$videoId',
          imageUrl: (snippet['thumbnails'] as Map<String, dynamic>? ?? {})['high']?['url'] as String? ?? '',
          publishedAt: DateTime.tryParse(snippet['publishedAt'] as String? ?? '') ?? DateTime.now(),
          source: snippet['channelTitle'] as String?,
          videoUrl: 'https://www.youtube.com/watch?v=$videoId',
        );
      }).toList();
    });
  }

  Map<String, String> get _apiFootballHeaders => <String, String>{
        'X-RapidAPI-Key': _apiFootballKey,
        'X-RapidAPI-Host': _apiFootballHost.isEmpty
            ? Uri.parse(ApiConstants.apiFootballBaseUrl).host
            : _apiFootballHost,
      };

  Map<String, String> get _footballDataHeaders => <String, String>{
        'X-Auth-Token': _footballDataKey,
      };

  Map<String, String> get _newsHeaders => <String, String>{
        'X-Api-Key': _newsApiKey,
      };

  Future<T> _requestWithRetry<T>(Future<T> Function() request) async {
    var attempt = 0;
    while (true) {
      try {
        attempt++;
        return await request();
      } catch (error, stackTrace) {
        ErrorHandler.logError(error, stackTrace);
        if (attempt >= AppConstants.maxRetryCount) {
          rethrow;
        }
        await Future<void>.delayed(const Duration(milliseconds: 500));
      }
    }
  }

  Match _parseFixture(Map<String, dynamic> fixture) {
    final fixtureInfo = fixture['fixture'] as Map<String, dynamic>? ?? {};
    final teams = fixture['teams'] as Map<String, dynamic>? ?? {};
    final goals = fixture['goals'] as Map<String, dynamic>? ?? {};
    final status = fixtureInfo['status'] as Map<String, dynamic>? ?? {};

    return Match(
      id: (fixtureInfo['id'] ?? '').toString(),
      date: DateTime.tryParse(fixtureInfo['date'] as String? ?? '') ?? DateTime.now(),
      homeTeam: (teams['home'] as Map<String, dynamic>? ?? {})['name'] as String? ?? 'Amedspor',
      awayTeam: (teams['away'] as Map<String, dynamic>? ?? {})['name'] as String? ?? 'Rakip',
      homeScore: goals['home'] as int?,
      awayScore: goals['away'] as int?,
      status: status['short'] as String? ?? 'NS',
      venue: (fixtureInfo['venue'] as Map<String, dynamic>? ?? {})['name'] as String? ?? 'Belirtilmedi',
      events: const [],
      statistics: null,
    );
  }
}

extension<T> on List<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
