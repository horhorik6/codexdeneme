import 'dart:developer';

import 'package:dio/dio.dart';

class ErrorHandler {
  static void logError(Object error, StackTrace stackTrace) {
    log('Error: $error', stackTrace: stackTrace);
  }

  static String getErrorMessage(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return 'Bağlantı zaman aşımına uğradı. Lütfen tekrar deneyin.';
        case DioExceptionType.badResponse:
          return 'Sunucudan beklenmedik bir cevap alındı.';
        case DioExceptionType.connectionError:
          return 'İnternet bağlantısı bulunamadı.';
        default:
          return 'Bir hata oluştu. Lütfen tekrar deneyin.';
      }
    }
    return 'Bir hata oluştu. Lütfen tekrar deneyin.';
  }
}
