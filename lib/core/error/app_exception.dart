sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

final class NetworkException extends AppException {
  const NetworkException([super.message = 'Network error']);
}

final class ApiException extends AppException {
  const ApiException([super.message = 'API error']);
}

final class CacheException extends AppException {
  const CacheException([super.message = 'Cache error']);
}

final class UnknownException extends AppException {
  const UnknownException([super.message = 'Unknown error']);
}
