import 'package:dio/dio.dart';
import 'package:rc0_flutter/core/error/app_exception.dart';
import 'package:rc0_flutter/core/network/api_response.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/core/network/dio_error_mapper.dart';
import 'package:rc0_flutter/features/auth/data/models/auth_response_dto.dart';
import 'package:rc0_flutter/features/auth/domain/entities/login_credentials.dart';
import 'package:rc0_flutter/features/auth/domain/entities/register_credentials.dart';

class RemoteAuthDatasource {
  RemoteAuthDatasource(this._dioClient);

  final DioClient _dioClient;

  Future<AuthResponseDto> login(LoginCredentials credentials) async {
    return _postAuth('/auth/login', {
      'username': credentials.username,
      'password': credentials.password,
    });
  }

  Future<AuthResponseDto> register(RegisterCredentials credentials) async {
    final body = <String, dynamic>{
      'username': credentials.username,
      'password': credentials.password,
      'email': credentials.email,
    };
    if (credentials.nickname != null && credentials.nickname!.isNotEmpty) {
      body['nickname'] = credentials.nickname;
    }
    return _postAuth('/auth/register', body);
  }

  Future<AuthTokensDto> refresh(String refreshToken) async {
    try {
      final response = await _dioClient.authDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final envelope = ApiResponse.fromJson(response.data!, null);
      if (!envelope.isSuccess) {
        throw ApiException(
          envelope.message.isNotEmpty ? envelope.message : '刷新登录状态失败',
        );
      }
      final data = envelope.data as Map<String, dynamic>?;
      if (data == null) {
        throw const ApiException('刷新响应为空');
      }
      return AuthTokensDto.fromJson(data);
    } on DioException catch (error) {
      throw NetworkException(mapDioError(error));
    }
  }

  Future<AuthUserDto> getCurrentUser() async {
    try {
      final response =
          await _dioClient.dio.get<Map<String, dynamic>>('/users/me');
      final envelope = ApiResponse.fromJson(response.data!, null);
      if (!envelope.isSuccess) {
        throw ApiException(
          envelope.message.isNotEmpty ? envelope.message : '获取用户信息失败',
        );
      }
      final data = envelope.data as Map<String, dynamic>?;
      if (data == null) {
        throw const ApiException('用户信息为空');
      }
      return AuthUserDto.fromMeJson(data);
    } on DioException catch (error) {
      throw NetworkException(mapDioError(error));
    }
  }

  Future<AuthResponseDto> _postAuth(
    String path,
    Map<String, dynamic> body,
  ) async {
    try {
      final response = await _dioClient.authDio.post<Map<String, dynamic>>(
        path,
        data: body,
      );
      final envelope = ApiResponse.fromJson(response.data!, null);
      if (!envelope.isSuccess) {
        throw ApiException(
          envelope.message.isNotEmpty ? envelope.message : '认证失败',
        );
      }
      final data = envelope.data as Map<String, dynamic>?;
      if (data == null) {
        throw const ApiException('认证响应为空');
      }
      return AuthResponseDto.fromJson(data);
    } on DioException catch (error) {
      throw NetworkException(mapDioError(error));
    }
  }
}
