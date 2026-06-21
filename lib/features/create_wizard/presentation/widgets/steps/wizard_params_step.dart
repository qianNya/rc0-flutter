import 'package:flutter/material.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/providers/create_wizard_provider.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/theme/wizard_colors.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/widgets/wizard_header.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_nodes.dart';

class WizardParamsStep extends StatelessWidget {
  const WizardParamsStep({
    super.key,
    required this.state,
    required this.notifier,
  });

  final CreateWizardState state;
  final CreateWizardNotifier notifier;

  static const _aspectRatios = ['16:9', '2.39:1', '4:3', '1:1'];
  static const _shotTypes = ['wide', 'medium', 'close', 'extreme_close'];

  @override
  Widget build(BuildContext context) {
    final manifest = state.manifest!;
    final items = <({int a, int s, int f, DraftFrame frame})>[];
    for (var a = 0; a < manifest.acts.length; a++) {
      for (var s = 0; s < manifest.acts[a].scenes.length; s++) {
        for (var f = 0; f < manifest.acts[a].scenes[s].frames.length; f++) {
          items.add((
            a: a,
            s: s,
            f: f,
            frame: manifest.acts[a].scenes[s].frames[f],
          ));
        }
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardSectionHeader(title: '参数'),
        const SizedBox(height: AppSpacing.lg),
        if (items.isEmpty)
          Text(
            '请先在画面步骤中添加分镜帧',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          )
        else
          ...items.map((item) {
            return Container(
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: WizardColors.sceneCardBackground,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.frame.data.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String>(
                    value: item.frame.data.aspectRatio,
                    decoration: const InputDecoration(labelText: '画幅比例'),
                    items: _aspectRatios
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        notifier.updateFrameParams(
                          item.a,
                          item.s,
                          item.f,
                          aspectRatio: v,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  DropdownButtonFormField<String>(
                    value: item.frame.data.shotType,
                    decoration: const InputDecoration(labelText: '景别'),
                    items: _shotTypes
                        .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                        .toList(),
                    onChanged: (v) {
                      if (v != null) {
                        notifier.updateFrameParams(
                          item.a,
                          item.s,
                          item.f,
                          shotType: v,
                        );
                      }
                    },
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
