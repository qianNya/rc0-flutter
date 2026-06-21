import 'package:flutter/material.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/providers/create_wizard_provider.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/theme/wizard_colors.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/widgets/wizard_header.dart';
import 'package:rc0_flutter/shared/widgets/app_primary_button.dart';

class WizardPublishStep extends StatelessWidget {
  const WizardPublishStep({
    super.key,
    required this.state,
    required this.onPublishLocal,
    required this.onPublishCloud,
  });

  final CreateWizardState state;
  final VoidCallback? onPublishLocal;
  final VoidCallback? onPublishCloud;

  @override
  Widget build(BuildContext context) {
    final manifest = state.manifest;
    final progress = state.uploadProgress;
    final isBusy = state.isUploading || state.isSaving;
    final isPublishedLocally =
        (manifest?.screenplay.data.publishStatus ?? 0) == 1;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardSectionHeader(title: '发布'),
        const SizedBox(height: AppSpacing.lg),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: WizardColors.sceneCardBackground,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                manifest?.screenplay.data.title ?? '未命名剧本',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '本地发布后可立即在设备上预览剧本，无需联网。',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              if (isPublishedLocally) ...[
                const SizedBox(height: AppSpacing.sm),
                const Text(
                  '已本地发布',
                  style: TextStyle(
                    color: WizardColors.stepActive,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        AppPrimaryButton(
          label: state.isSaving ? '发布中...' : '本地发布',
          backgroundColor: WizardColors.stepActive,
          onPressed: isBusy ? null : onPublishLocal,
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          height: 48,
          child: OutlinedButton(
            onPressed: isBusy ? null : onPublishCloud,
            style: OutlinedButton.styleFrom(
              foregroundColor: WizardColors.linkAction,
              side: const BorderSide(color: WizardColors.linkAction),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
            ),
            child: Text(
              state.isUploading ? '同步中...' : '同步到云端',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        if (state.isUploading && progress != null) ...[
          const SizedBox(height: AppSpacing.lg),
          LinearProgressIndicator(
            value: progress.fraction,
            color: WizardColors.stepActive,
            backgroundColor: WizardColors.stepInactive,
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            progress.message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}
