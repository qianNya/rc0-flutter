import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/cine_preset/domain/entities/cine_preset.dart';
import 'package:rc0_flutter/features/cine_preset/presentation/providers/cine_preset_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_bottom_inset.dart';
import 'package:rc0_flutter/shared/widgets/app_primary_button.dart';

class CinePresetView extends ConsumerWidget {
  const CinePresetView({super.key, required this.templateId});

  final String templateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cinePresetProvider(templateId));

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('参数预设'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: state.isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      itemCount: state.presets.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.md),
                      itemBuilder: (context, index) {
                        final preset = state.presets[index];
                        final selected = preset.id == state.selectedPresetId;
                        return GestureDetector(
                          onTap: () => ref
                              .read(cinePresetProvider(templateId).notifier)
                              .selectPreset(preset.id),
                          child: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primary.withValues(alpha: 0.08)
                                  : AppColors.background,
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.border,
                              ),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.sm,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: preset.thumbnailUrl,
                                    width: 72,
                                    height: 48,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        preset.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall
                                            ?.copyWith(fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: AppSpacing.xs),
                                      Text(
                                        '${preset.aspectRatio} · ${preset.frameRate}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall
                                            ?.copyWith(
                                              color: AppColors.textSecondary,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (selected)
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.primary,
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  if (state.detail != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      child: _DetailCard(detail: state.detail!),
                    ),
                  AppBottomInset(
                    color: AppColors.surface,
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: const AppPrimaryButton(label: '应用到当前模板'),
                  ),
                ],
              ),
    );
  }
}

class _DetailCard extends StatelessWidget {
  const _DetailCard({required this.detail});

  final CinePresetDetail detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '参数详情',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          _DetailRow('画幅比例', detail.aspectRatio),
          _DetailRow('帧率', detail.frameRate),
          _DetailRow('色彩空间', detail.colorSpace),
          _DetailRow('LUT', detail.lut),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
