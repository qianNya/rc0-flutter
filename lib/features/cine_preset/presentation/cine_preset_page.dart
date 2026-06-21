import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/features/cine_preset/presentation/cine_preset_view.dart';

class CinePresetPage extends ConsumerWidget {
  const CinePresetPage({super.key, required this.templateId});

  final String templateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CinePresetView(templateId: templateId);
  }
}
