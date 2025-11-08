import 'dart:developer';

import 'package:dio/dio.dart';

class ErrorHandler {
  ErrorHandler._();

  static void logError(Object error, StackTrace stackTrace) {
    log('Error: $error', stackTrace: stackTrace);
  }

  static String getErrorMessage(Object error) {
    if (error is DioException) {
      return error.message ?? 'Bilinmeyen bir hata oluştu.';
    }
    return 'Beklenmedik bir hata oluştu.';
  }
}
