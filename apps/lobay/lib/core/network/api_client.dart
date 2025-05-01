import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lobay/core/network/api_exception.dart';
import 'package:lobay/core/network/app_config.dart';
import 'package:lobay/core/network/network_constants.dart';
import 'package:lobay/services/shared_pref_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiClient {
  late Dio _dio;

  ApiClient() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.baseUrl,
      sendTimeout: Duration(seconds: RequestTimeoutConstants.sendTimeout),
      connectTimeout: Duration(seconds: RequestTimeoutConstants.connectTimeout),
      receiveTimeout: Duration(seconds: RequestTimeoutConstants.receiveTimeout),
      receiveDataWhenStatusError: true,
      followRedirects: false,
      validateStatus: (status) {
        return status! <= 500;
      },
      headers: {
        'Accept': 'application/json',
      },
    ));

    // Logging Interceptor for debugging
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
    ));

    // Authentication Interceptor
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token =
            await PreferencesManager.getInstance().getStringValue('token', '');
        if (kDebugMode) {
          print('Token to send: $token');
        }
        if (token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (DioException e, handler) {
        return handler.reject(e);
      },
    ));
  }

  Future<Response> get(String path,
      {Map<String, dynamic>? queryParams,
      dynamic data,
      required Function() retryCallback}) async {
    try {
      return await _dio.get(path, queryParameters: queryParams, data: data);
    } catch (e) {
      throw ApiException.handleError(e, retryCallback);
    }
  }

  Future<Response> post(String path,
      {dynamic data, required Function() retryCallback}) async {
    try {
      return await _dio.post(path, data: data);
    } catch (e) {
      throw ApiException.handleError(e, retryCallback);
    }
  }

  Future<Response> put(String path,
      {dynamic data, required Function() retryCallback}) async {
    try {
      return await _dio.put(path, data: data);
    } catch (e) {
      throw ApiException.handleError(e, retryCallback);
    }
  }

  Future<Response> delete(String path, Function() retryCallback) async {
    try {
      return await _dio.delete(path);
    } catch (e) {
      throw ApiException.handleError(e, retryCallback);
    }
  }
}
