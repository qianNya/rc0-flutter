import 'package:rc0_flutter/core/error/app_exception.dart';
import 'package:rc0_flutter/core/network/token_store.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/auth/data/datasources/remote_auth_datasource.dart';
import 'package:rc0_flutter/features/auth/data/models/auth_response_dto.dart';
import 'package:rc0_flutter/features/auth/domain/entities/auth_session.dart';
import 'package:rc0_flutter/features/auth/domain/entities/auth_tokens.dart';
import 'package:rc0_flutter/features/auth/domain/entities/auth_user.dart';
import 'package:rc0_flutter/features/auth/domain/entities/login_credentials.dart';
import 'package:rc0_flutter/features/auth/domain/entities/register_credentials.dart';
import 'package:rc0_flutter/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._datasource, this._tokenStore);

  final RemoteAuthDatasource _datasource;
  final TokenStore _tokenStore;

  @override
  Future<Result<AuthSession>> login(LoginCredentials credentials) async {
    try {
      final response = await _datasource.login(credentials);
      await _saveTokens(response.tokens);
      return Success(
        AuthSession(
          user: response.user.toEntity(),
          tokens: response.tokens.toEntity(),
        ),
      );
    } on AppException catch (error) {
      return Failure(error);
    } catch (error) {
      return Failure(UnknownException(error.toString()));
    }
  }

  @override
  Future<Result<AuthSession>> register(RegisterCredentials credentials) async {
    try {
      final response = await _datasource.register(credentials);
      await _saveTokens(response.tokens);
      return Success(
        AuthSession(
          user: response.user.toEntity(),
          tokens: response.tokens.toEntity(),
        ),
      );
    } on AppException catch (error) {
      return Failure(error);
    } catch (error) {
      return Failure(UnknownException(error.toString()));
    }
  }

  @override
  Future<Result<AuthUser>> getCurrentUser() async {
    try {
      final token = await _tokenStore.getAccessToken();
      if (token == null || token.isEmpty) {
        return const Failure(ApiException('未登录'));
      }
      final user = await _datasource.getCurrentUser();
      return Success(user.toEntity());
    } on AppException catch (error) {
      return Failure(error);
    } catch (error) {
      return Failure(UnknownException(error.toString()));
    }
  }

  @override
  Future<Result<AuthTokens>> refreshSession() async {
    try {
      final refreshToken = await _tokenStore.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return const Failure(ApiException('未登录'));
      }
      final tokens = await _datasource.refresh(refreshToken);
      await _saveTokens(tokens);
      return Success(tokens.toEntity());
    } on AppException catch (error) {
      return Failure(error);
    } catch (error) {
      return Failure(UnknownException(error.toString()));
    }
  }

  Future<void> _saveTokens(AuthTokensDto tokens) async {
    await _tokenStore.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
      expiresInSeconds: tokens.expiresIn,
    );
  }
}
