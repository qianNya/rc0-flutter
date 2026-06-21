import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/core/network/token_store.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/auth/data/datasources/remote_auth_datasource.dart';
import 'package:rc0_flutter/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:rc0_flutter/features/auth/domain/entities/auth_session.dart';
import 'package:rc0_flutter/features/auth/domain/entities/auth_tokens.dart';
import 'package:rc0_flutter/features/auth/domain/entities/auth_user.dart';
import 'package:rc0_flutter/features/auth/domain/entities/login_credentials.dart';
import 'package:rc0_flutter/features/auth/domain/entities/register_credentials.dart';
import 'package:rc0_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:rc0_flutter/features/auth/domain/usecases/login_usecase.dart';
import 'package:rc0_flutter/features/auth/domain/usecases/register_usecase.dart';

final remoteAuthDatasourceProvider = Provider<RemoteAuthDatasource>((ref) {
  return RemoteAuthDatasource(ref.watch(dioClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    ref.watch(remoteAuthDatasourceProvider),
    ref.watch(tokenStoreProvider),
  );
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final registerUseCaseProvider = Provider<RegisterUseCase>((ref) {
  return RegisterUseCase(ref.watch(authRepositoryProvider));
});

enum AuthStatus { loading, guest, authenticated }

class AuthState {
  const AuthState({
    this.status = AuthStatus.loading,
    this.userId,
    this.displayName,
    this.email,
  });

  final AuthStatus status;
  final String? userId;
  final String? displayName;
  final String? email;

  AuthState copyWith({
    AuthStatus? status,
    String? userId,
    String? displayName,
    String? email,
  }) {
    return AuthState(
      status: status ?? this.status,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier(
    this._repository,
    this._loginUseCase,
    this._registerUseCase,
    this._tokenStore,
  ) : super(const AuthState());

  final AuthRepository _repository;
  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final TokenStore _tokenStore;

  Future<void> restoreSession() async {
    final token = await _tokenStore.getAccessToken();
    if (token == null || token.isEmpty) {
      state = const AuthState(status: AuthStatus.guest);
      return;
    }

    final result = await _repository.getCurrentUser();
    if (result is Failure<AuthUser>) {
      final refresh = await _repository.refreshSession();
      if (refresh is Success<AuthTokens>) {
        final retry = await _repository.getCurrentUser();
        if (retry is Success<AuthUser>) {
          _applyUser((retry).data);
          return;
        }
      }
      await _tokenStore.clear();
      state = const AuthState(status: AuthStatus.guest);
      return;
    }

    _applyUser((result as Success<AuthUser>).data);
  }

  Future<Result<AuthSession>> login(LoginCredentials credentials) async {
    final result = await _loginUseCase(credentials);
    if (result is Success<AuthSession>) {
      _applySession(result.data);
    }
    return result;
  }

  Future<Result<AuthSession>> register(RegisterCredentials credentials) async {
    final result = await _registerUseCase(credentials);
    if (result is Success<AuthSession>) {
      _applySession(result.data);
    }
    return result;
  }

  Future<void> logout() async {
    await _tokenStore.clear();
    state = const AuthState(status: AuthStatus.guest);
  }

  void _applySession(AuthSession session) {
    state = AuthState(
      status: AuthStatus.authenticated,
      userId: session.user.id,
      displayName: session.user.nickname.isNotEmpty
          ? session.user.nickname
          : session.user.username,
      email: session.user.email,
    );
  }

  void _applyUser(AuthUser user) {
    state = AuthState(
      status: AuthStatus.authenticated,
      userId: user.id,
      displayName: user.nickname.isNotEmpty ? user.nickname : user.username,
      email: user.email,
    );
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final notifier = AuthNotifier(
    ref.watch(authRepositoryProvider),
    ref.watch(loginUseCaseProvider),
    ref.watch(registerUseCaseProvider),
    ref.watch(tokenStoreProvider),
  );

  ref.listen(authLogoutBridgeProvider, (previous, next) {
    if ((previous ?? 0) < next) {
      notifier.logout();
    }
  });

  return notifier;
});
