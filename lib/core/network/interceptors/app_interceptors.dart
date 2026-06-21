import 'dart:async';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:rc0_flutter/core/network/api_response.dart';
import 'package:rc0_flutter/core/network/token_store.dart';

typedef SessionExpiredCallback = Future<void> Function();
typedef RefreshTokensCallback = Future<bool> Function();

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._tokenStore);

  final TokenStore _tokenStore;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _tokenStore.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class TokenRefreshInterceptor extends Interceptor {
  TokenRefreshInterceptor({
    required RefreshTokensCallback onRefresh,
    required SessionExpiredCallback onSessionExpired,
  }) : _onRefresh = onRefresh,
       _onSessionExpired = onSessionExpired;

  final RefreshTokensCallback _onRefresh;
  final SessionExpiredCallback _onSessionExpired;

  Completer<bool>? _refreshCompleter;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 || _isAuthPath(err.requestOptions.path)) {
      handler.next(err);
      return;
    }

    try {
      final refreshed = await _refreshTokens();
      if (!refreshed) {
        await _onSessionExpired();
        handler.next(err);
        return;
      }

      final response = await _retry(err.requestOptions);
      handler.resolve(response);
    } catch (retryError) {
      if (retryError is DioException) {
        handler.next(retryError);
      } else {
        handler.next(err);
      }
    }
  }

  bool _isAuthPath(String path) => path.startsWith('/auth/');

  Future<bool> _refreshTokens() async {
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<bool>();
    try {
      final result = await _onRefresh();
      _refreshCompleter!.complete(result);
      return result;
    } catch (error) {
      _refreshCompleter!.complete(false);
      return false;
    } finally {
      _refreshCompleter = null;
    }
  }

  Future<Response<dynamic>> _retry(RequestOptions requestOptions) async {
    final dio = requestOptions.extra['dio'] as Dio?;
    if (dio == null) {
      throw DioException(
        requestOptions: requestOptions,
        message: 'Missing dio instance for retry',
      );
    }

    final options = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
      responseType: requestOptions.responseType,
      contentType: requestOptions.contentType,
      extra: requestOptions.extra,
      validateStatus: requestOptions.validateStatus,
      receiveTimeout: requestOptions.receiveTimeout,
      sendTimeout: requestOptions.sendTimeout,
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
      cancelToken: requestOptions.cancelToken,
      onReceiveProgress: requestOptions.onReceiveProgress,
      onSendProgress: requestOptions.onSendProgress,
    );
  }
}

class AppLogInterceptor extends Interceptor {
  AppLogInterceptor({Logger? logger}) : _logger = logger ?? Logger();

  final Logger _logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.d('→ ${options.method} ${options.uri}');
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    _logger.d('← ${response.statusCode} ${response.requestOptions.uri}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '✕ ${err.requestOptions.method} ${err.requestOptions.uri}: ${err.message}',
    );
    handler.next(err);
  }
}

/// Parses token pair from `/auth/refresh` response envelope.
Future<bool> parseAndSaveRefreshResponse({
  required Response<Map<String, dynamic>> response,
  required TokenStore tokenStore,
}) async {
  final envelope = ApiResponse.fromJson(response.data!, null);
  if (!envelope.isSuccess) return false;

  final data = envelope.data as Map<String, dynamic>?;
  if (data == null) return false;

  final accessToken = data['access_token'] as String? ?? '';
  final refreshToken = data['refresh_token'] as String? ?? '';
  if (accessToken.isEmpty || refreshToken.isEmpty) return false;

  await tokenStore.saveTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
    expiresInSeconds: data['expires_in'] as int?,
  );
  return true;
}
