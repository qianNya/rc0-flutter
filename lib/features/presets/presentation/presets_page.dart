import 'package:flutter/material.dart';
import 'package:rc0_flutter/core/theme/app_theme.dart';
import 'package:rc0_flutter/features/cine_preset/presentation/cine_preset_view.dart';

class PresetsPage extends StatelessWidget {
  const PresetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light,
      child: const CinePresetView(templateId: 'default'),
    );
  }
}
