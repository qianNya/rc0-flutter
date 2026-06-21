import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/network/api_config.dart';
import 'package:rc0_flutter/core/network/interceptors/app_interceptors.dart';
import 'package:rc0_flutter/core/network/token_store.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());

/// Incremented when token refresh fails; listeners should log the user out.
final authLogoutBridgeProvider = StateProvider<int>((ref) => 0);

final dioClientProvider = Provider<DioClient>((ref) {
  final client = DioClient(tokenStore: ref.watch(tokenStoreProvider));
  client.onSessionExpired = () async {
    await ref.read(tokenStoreProvider).clear();
    ref.read(authLogoutBridgeProvider.notifier).state++;
  };
  return client;
});

class DioClient {
  DioClient({TokenStore? tokenStore}) {
    final store = tokenStore ?? TokenStore();
    _tokenStore = store;

    final baseOptions = BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    );

    _authDio = Dio(baseOptions);
    _authDio.interceptors.add(AppLogInterceptor());

    _apiDio = Dio(baseOptions);
    _apiDio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.extra['dio'] = _apiDio;
          handler.next(options);
        },
      ),
      AuthInterceptor(store),
      TokenRefreshInterceptor(
        onRefresh: refreshTokens,
        onSessionExpired: () async {
          await onSessionExpired?.call();
        },
      ),
      AppLogInterceptor(),
    ]);
  }

  late final TokenStore _tokenStore;
  late final Dio _authDio;
  late final Dio _apiDio;

  SessionExpiredCallback? onSessionExpired;

  Dio get dio => _apiDio;

  Dio get authDio => _authDio;

  Future<bool> refreshTokens() async {
    final refreshToken = await _tokenStore.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return false;
    }

    try {
      final response = await _authDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      return parseAndSaveRefreshResponse(
        response: response,
        tokenStore: _tokenStore,
      );
    } on DioException {
      return false;
    }
  }
}
