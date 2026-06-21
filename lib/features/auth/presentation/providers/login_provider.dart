import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/error/app_exception.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/auth/domain/entities/auth_session.dart';
import 'package:rc0_flutter/features/auth/domain/entities/login_credentials.dart';
import 'package:rc0_flutter/features/auth/presentation/providers/auth_provider.dart';

class LoginState {
  const LoginState({
    this.isLoading = false,
    this.error,
  });

  final bool isLoading;
  final String? error;

  LoginState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return LoginState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class LoginNotifier extends StateNotifier<LoginState> {
  LoginNotifier(this._authNotifier) : super(const LoginState());

  final AuthNotifier _authNotifier;

  Future<bool> submit({
    required String username,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _authNotifier.login(
      LoginCredentials(username: username.trim(), password: password),
    );
    if (result is Failure<AuthSession>) {
      final message = result.exception is AppException
          ? (result.exception as AppException).message
          : result.exception.toString();
      state = state.copyWith(isLoading: false, error: message);
      return false;
    }
    state = state.copyWith(isLoading: false);
    return true;
  }

  void clearError() {
    if (state.error != null) {
      state = state.copyWith(error: null);
    }
  }
}

final loginProvider = StateNotifierProvider.autoDispose<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref.read(authProvider.notifier)),
);
