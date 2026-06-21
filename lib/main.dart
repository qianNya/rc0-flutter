import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/app/app.dart';
import 'package:rc0_flutter/core/system/app_system_ui.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSystemUi.configure();
  runApp(
    const ProviderScope(
      child: RcoApp(),
    ),
  );
}
