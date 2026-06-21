import 'package:dio/dio.dart';

/// Maps [DioException] to user-facing Chinese messages.
String mapDioError(DioException error) {
  final envelopeMessage = _envelopeMessage(error);

  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return '连接超时，请检查网络';
    case DioExceptionType.connectionError:
      return '无法连接服务器，请确认后端已启动且地址正确';
    case DioExceptionType.badResponse:
      if (envelopeMessage != null && envelopeMessage.isNotEmpty) {
        return envelopeMessage;
      }
      final status = error.response?.statusCode;
      if (status != null && status >= 500) {
        return '服务器繁忙，请稍后重试';
      }
      return switch (status) {
        400 => '请求参数错误',
        401 => '未登录或登录已过期',
        403 => '没有权限执行此操作',
        404 => '请求的资源不存在',
        409 => '资源冲突，请稍后重试',
        422 => '输入数据不符合要求',
        _ => '请求失败${status != null ? '（$status）' : ''}',
      };
    case DioExceptionType.cancel:
      return '请求已取消';
    case DioExceptionType.badCertificate:
      return '证书验证失败';
    case DioExceptionType.unknown:
      final message = error.message?.toLowerCase() ?? '';
      if (message.contains('connection refused') ||
          message.contains('failed host lookup') ||
          message.contains('network is unreachable')) {
        return '无法连接服务器，请确认后端已启动且地址正确';
      }
      return envelopeMessage ?? '网络异常，请稍后重试';
  }
}

String? _envelopeMessage(DioException error) {
  final data = error.response?.data;
  if (data is Map<String, dynamic>) {
    final message = data['message'];
    if (message is String && message.isNotEmpty) {
      return message;
    }
  }
  return null;
}
