import 'dart:io';

import 'package:flutter/foundation.dart';

/// API base URL resolution.
///
/// Override for physical devices: `--dart-define=API_BASE_URL=http://<LAN_IP>:8080`
abstract final class ApiConfig {
  static String get baseUrl {
    const fromEnv = String.fromEnvironment('API_BASE_URL');
    if (fromEnv.isNotEmpty) return fromEnv;
    if (kIsWeb) return 'http://192.168.3.42:8080';
    if (Platform.isAndroid) return 'http://192.168.3.42:8080';
    return 'http://192.168.3.42:8080';
  }

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 15);
}
