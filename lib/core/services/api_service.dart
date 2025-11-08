import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../constants/api_constants.dart';
import '../constants/app_constants.dart';
import '../utils/error_handler.dart';

class ApiService {
  ApiService({Dio? dio}) : _dio = dio ?? Dio();

  final Dio _dio;

  Map<String, String> get _apiFootballHeaders => {
        'X-RapidAPI-Key': dotenv.env['API_FOOTBALL_KEY'] ?? '',
        'X-RapidAPI-Host': ApiConstants.apiFootballHost,
      };

  Map<String, String> get _footballDataHeaders => {
        'X-Auth-Token': dotenv.env['FOOTBALL_DATA_TOKEN'] ?? '',
      };

  Map<String, String> get _newsHeaders => {
        'X-Api-Key': dotenv.env['NEWS_API_KEY'] ?? '',
      };

  Future<Response<T>> _retryRequest<T>(
    Future<Response<T>> Function() request,
  ) async {
    int attempt = 0;
    while (true) {
      try {
        return await request();
      } on DioException catch (error, stackTrace) {
        attempt++;
        if (attempt >= AppConstants.maxRetryCount) {
          ErrorHandler.logError(error, stackTrace);
          rethrow;
        }
        await Future<void>.delayed(Duration(milliseconds: 500 * attempt));
      }
    }
  }

  Future<Response<dynamic>> getUpcomingMatches() {
    return _retryRequest(
      () => _dio.get<dynamic>(
        '${ApiConstants.apiFootballBaseUrl}/fixtures',
        options: Options(headers: _apiFootballHeaders),
        queryParameters: {
          'team': dotenv.env['AMEDSPOR_TEAM_ID'],
          'status': 'NS',
        },
      ),
    );
  }

  Future<Response<dynamic>> getLiveMatches() {
    return _retryRequest(
      () => _dio.get<dynamic>(
        '${ApiConstants.apiFootballBaseUrl}/fixtures',
        options: Options(headers: _apiFootballHeaders),
        queryParameters: {
          'team': dotenv.env['AMEDSPOR_TEAM_ID'],
          'live': 'all',
        },
      ),
    );
  }

  Future<Response<dynamic>> getPastMatches({int page = 1}) {
    return _retryRequest(
      () => _dio.get<dynamic>(
        '${ApiConstants.apiFootballBaseUrl}/fixtures',
        options: Options(headers: _apiFootballHeaders),
        queryParameters: {
          'team': dotenv.env['AMEDSPOR_TEAM_ID'],
          'status': 'FT',
          'page': page,
        },
      ),
    );
  }

  Future<Response<dynamic>> getSeasonFixture() {
    return _retryRequest(
      () => _dio.get<dynamic>(
        '${ApiConstants.footballDataBaseUrl}/teams/${dotenv.env['FOOTBALL_DATA_TEAM_ID']}/matches',
        options: Options(headers: _footballDataHeaders),
      ),
    );
  }

  Future<Response<dynamic>> getNewsArticles() {
    return _retryRequest(
      () => _dio.get<dynamic>(
        '${ApiConstants.newsBaseUrl}/everything',
        options: Options(headers: _newsHeaders),
        queryParameters: {
          'q': ApiConstants.queryAmedspor,
          'language': 'tr',
        },
      ),
    );
  }

  Future<Response<dynamic>> getYoutubeHighlights() {
    return _retryRequest(
      () => _dio.get<dynamic>(
        '${ApiConstants.youtubeBaseUrl}/search',
        queryParameters: {
          'part': 'snippet',
          'q': ApiConstants.queryAmedsporMatchHighlights,
          'type': 'video',
          'key': dotenv.env['YOUTUBE_API_KEY'],
        },
      ),
    );
  }
}
