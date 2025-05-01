import 'package:dio/dio.dart';

class ApiException implements Exception {
  final String message;

  ApiException(this.message);

  static ApiException fromDioError(
      DioException error, Function() retryCallback) {
    retryCallback();
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException('Connection timeout, please try again.');
      case DioExceptionType.sendTimeout:
        return ApiException('Request timeout, please try again.');
      case DioExceptionType.receiveTimeout:
        return ApiException('Response timeout, please try again.');
      case DioExceptionType.badResponse:
        return ApiException(_handleError(error.response?.statusCode));
      case DioExceptionType.cancel:
        return ApiException('Request cancelled.');
      default:
        return ApiException('Something went wrong, please try again.');
    }
  }

  static String _handleError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request.';
      case 401:
        return 'Unauthorized, please login again.';
      case 403:
        return 'Forbidden access.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Internal server error, please try later.';
      default:
        return 'Unexpected error, please try again.';
    }
  }

  static Exception handleError(dynamic error, Function() retryCallback) {
    if (error is DioException) {
      return fromDioError(error, retryCallback);
    } else {
      return Exception('Unexpected error occurred.');
    }
  }
}
