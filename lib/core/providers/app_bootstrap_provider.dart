import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/features/auth/presentation/providers/auth_provider.dart';

/// Initializes auth session on app start.
final appBootstrapProvider = FutureProvider<void>((ref) async {
  await ref.read(authProvider.notifier).restoreSession();
});
