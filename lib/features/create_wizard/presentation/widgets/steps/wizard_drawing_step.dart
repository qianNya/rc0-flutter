import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/providers/create_wizard_provider.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/theme/wizard_colors.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/widgets/wizard_header.dart';
import 'package:rc0_flutter/features/screenplay/presentation/providers/screenplay_providers.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_asset.dart';
import 'package:rc0_flutter/shared/widgets/draft_image.dart';

class WizardDrawingStep extends ConsumerWidget {
  const WizardDrawingStep({
    super.key,
    required this.state,
    required this.notifier,
  });

  final CreateWizardState state;
  final CreateWizardNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manifest = state.manifest!;
    final actIndex = state.selectedActIndex.clamp(0, manifest.acts.length - 1);
    final act = manifest.acts[actIndex];
    final sceneIndex =
        state.selectedSceneIndex.clamp(0, act.scenes.length - 1);
    final scene = act.scenes[sceneIndex];
    final storage = ref.watch(draftStorageServiceProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardSectionHeader(title: '画面'),
        const SizedBox(height: AppSpacing.lg),
        DropdownButtonFormField<int>(
          value: actIndex,
          decoration: const InputDecoration(labelText: '选择幕'),
          items: manifest.acts.asMap().entries.map((e) {
            return DropdownMenuItem(
              value: e.key,
              child: Text('Act ${e.key + 1} ${e.value.data.title}'),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) notifier.selectScene(v, 0);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<int>(
          value: sceneIndex,
          decoration: const InputDecoration(labelText: '选择场景'),
          items: act.scenes.asMap().entries.map((e) {
            return DropdownMenuItem(
              value: e.key,
              child: Text(e.value.data.title),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) notifier.selectScene(actIndex, v);
          },
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          scene.data.title,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '${scene.frames.length} 帧',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ...scene.frames.map((frame) {
              final assetRef = frame.data.imageAssetRef;
              return FutureBuilder<String>(
                future: storage.draftRootFor(manifest.draftId),
                builder: (context, snapshot) {
                  String? url;
                  if (snapshot.hasData && assetRef != null) {
                    final asset = manifest.assets[assetRef];
                    url = asset?.localUri != null
                        ? '${snapshot.data}/${asset!.localUri}'
                        : asset?.remoteUrl;
                  }
                  return DraftImage(
                    imageUrl: url,
                    width: 72,
                    height: 72,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  );
                },
              );
            }),
            GestureDetector(
              onTap: () => _addFrame(context, ref, actIndex, sceneIndex),
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: WizardColors.sceneCardBackground,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.add, color: WizardColors.linkAction),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _addFrame(
    BuildContext context,
    WidgetRef ref,
    int actIndex,
    int sceneIndex,
  ) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final storage = ref.read(draftStorageServiceProvider);
    final manifest = state.manifest!;
    final assetRef = storage.newAssetRef('frame');
    final frameId = 'f${DateTime.now().microsecondsSinceEpoch}';
    final rel = await storage.registerLocalAsset(
      draftId: manifest.draftId,
      assetRef: assetRef,
      kind: DraftAssetKind.frameImage,
      sourceFile: File(picked.path),
      relativePath: 'assets/frames/$frameId.jpg',
    );
    await notifier.addFrameFromFile(
      actIndex,
      sceneIndex,
      File(picked.path),
      assetRef,
      rel,
    );
  }
}
