import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/providers/create_wizard_provider.dart';
import 'package:rc0_flutter/features/screenplay/presentation/providers/screenplay_providers.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/mappers/to_display_tree_mapper.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_asset.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_nodes.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/screenplay_draft_manifest.dart';
import 'package:rc0_flutter/shared/widgets/app_bottom_inset.dart';
import 'package:rc0_flutter/shared/widgets/app_primary_button.dart';
import 'package:rc0_flutter/shared/widgets/draft_image.dart';

class CreateWizardView extends ConsumerWidget {
  const CreateWizardView({super.key, this.draftId});

  final String? draftId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (draftId != null) {
      return _CreateWizardBody(
        state: ref.watch(createWizardFamilyProvider(draftId)),
        notifier: ref.read(createWizardFamilyProvider(draftId).notifier),
      );
    }
    return _CreateWizardBody(
      state: ref.watch(createWizardProvider),
      notifier: ref.read(createWizardProvider.notifier),
    );
  }
}

class _CreateWizardBody extends ConsumerWidget {
  const _CreateWizardBody({required this.state, required this.notifier});

  final CreateWizardState state;
  final CreateWizardNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const stepTitles = [
      '基本信息',
      '结构搭建',
      '分镜绘制',
      '参数设置',
      '预览审核',
      '发布',
    ];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('创作向导'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
      ),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.manifest == null
          ? Center(child: Text(state.error ?? '加载失败'))
          : Column(
              children: [
                _StepProgress(
                  currentStep: state.currentStep,
                  labels: stepTitles,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    children: [
                      Text(
                        '第 ${state.currentStep} 步：${stepTitles[state.currentStep - 1]}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      _StepBody(state: state, notifier: notifier),
                    ],
                  ),
                ),
                AppBottomInset(
                  color: AppColors.surface,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      if (state.currentStep > 1)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: notifier.previousStep,
                            child: const Text('上一步'),
                          ),
                        ),
                      if (state.currentStep > 1)
                        const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        flex: 2,
                        child: AppPrimaryButton(
                          label: state.currentStep == CreateWizardState.totalSteps
                              ? (state.isUploading ? '发布中...' : '发布')
                              : '下一步',
                          onPressed: state.isUploading
                              ? null
                              : () => _onPrimaryAction(
                                  context,
                                  state,
                                  notifier,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _onPrimaryAction(
    BuildContext context,
    CreateWizardState state,
    CreateWizardNotifier notifier,
  ) async {
    if (state.currentStep < CreateWizardState.totalSteps) {
      await notifier.nextStep();
      return;
    }
    final synced = await notifier.publish();
    if (synced != null && context.mounted) {
      final remoteId = synced.screenplay.remoteId;
      if (remoteId != null) {
        context.go(AppRoutes.screenplayDetailPath('$remoteId'));
      } else {
        context.go(AppRoutes.screenplayDetailPath(synced.draftId));
      }
    } else if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('发布失败，请重试')),
      );
    }
  }
}

class _StepBody extends ConsumerWidget {
  const _StepBody({required this.state, required this.notifier});

  final CreateWizardState state;
  final CreateWizardNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final manifest = state.manifest!;
    return switch (state.currentStep) {
      1 => _BasicInfoStep(manifest: manifest, notifier: notifier),
      2 => _StructureStep(manifest: manifest, notifier: notifier),
      3 => _DrawingStep(state: state, notifier: notifier),
      4 => _ParamsStep(state: state, notifier: notifier),
      5 => _ReviewStep(manifest: manifest),
      6 => _PublishStep(state: state),
      _ => const SizedBox.shrink(),
    };
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({required this.currentStep, required this.labels});

  final int currentStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: List.generate(labels.length, (index) {
          final step = index + 1;
          final active = step <= currentStep;
          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(
                      color: active ? AppColors.primary : AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < labels.length - 1)
                  const SizedBox(width: AppSpacing.xs),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _BasicInfoStep extends ConsumerWidget {
  const _BasicInfoStep({required this.manifest, required this.notifier});

  final ScreenplayDraftManifest manifest;
  final CreateWizardNotifier notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(draftStorageServiceProvider);
    final coverRef = manifest.screenplay.data.coverAssetRef;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _pickCover(context, ref, storage),
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.border),
              ),
              child: coverRef != null
                  ? FutureBuilder<String>(
                      future: storage.draftRootFor(manifest.draftId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final asset = manifest.assets[coverRef];
                        final path = asset?.localUri != null
                            ? '${snapshot.data}/${asset!.localUri}'
                            : asset?.remoteUrl;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                          child: DraftImage(imageUrl: path, fit: BoxFit.cover),
                        );
                      },
                    )
                  : const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_photo_alternate_outlined, size: 40),
                          SizedBox(height: AppSpacing.sm),
                          Text('添加封面'),
                        ],
                      ),
                    ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        TextField(
          decoration: const InputDecoration(labelText: '标题'),
          controller: TextEditingController(text: manifest.screenplay.data.title)
            ..selection = TextSelection.collapsed(
              offset: manifest.screenplay.data.title.length,
            ),
          onChanged: notifier.updateTitle,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          decoration: const InputDecoration(labelText: '副标题'),
          controller:
              TextEditingController(text: manifest.screenplay.data.subtitle)
                ..selection = TextSelection.collapsed(
                  offset: manifest.screenplay.data.subtitle.length,
                ),
          onChanged: notifier.updateSubtitle,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          decoration: const InputDecoration(labelText: '简介'),
          maxLines: 3,
          controller:
              TextEditingController(text: manifest.screenplay.data.summary)
                ..selection = TextSelection.collapsed(
                  offset: manifest.screenplay.data.summary.length,
                ),
          onChanged: notifier.updateSummary,
        ),
      ],
    );
  }

  Future<void> _pickCover(
    BuildContext context,
    WidgetRef ref,
    dynamic storage,
  ) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final assetRef = storage.newAssetRef('cover');
    final rel = await storage.registerLocalAsset(
      draftId: manifest.draftId,
      assetRef: assetRef,
      kind: DraftAssetKind.cover,
      sourceFile: File(picked.path),
      relativePath: 'assets/cover.jpg',
    );
    await notifier.setCoverFromFile(File(picked.path), assetRef, rel);
  }
}

class _StructureStep extends StatelessWidget {
  const _StructureStep({required this.manifest, required this.notifier});

  final ScreenplayDraftManifest manifest;
  final CreateWizardNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...manifest.acts.asMap().entries.map((entry) {
          final actIndex = entry.key;
          final act = entry.value;
          return _ActCard(
            act: act,
            actIndex: actIndex,
            notifier: notifier,
          );
        }),
        const SizedBox(height: AppSpacing.md),
        OutlinedButton.icon(
          onPressed: notifier.addAct,
          icon: const Icon(Icons.add),
          label: const Text('添加幕'),
        ),
      ],
    );
  }
}

class _ActCard extends StatelessWidget {
  const _ActCard({
    required this.act,
    required this.actIndex,
    required this.notifier,
  });

  final DraftAct act;
  final int actIndex;
  final CreateWizardNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            act.data.title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: act.scenes.length,
            onReorder: (oldIndex, newIndex) =>
                notifier.reorderScenes(actIndex, oldIndex, newIndex),
            itemBuilder: (context, sceneIndex) {
              final scene = act.scenes[sceneIndex];
              return ListTile(
                key: ValueKey(scene.localId),
                leading: const Icon(Icons.drag_handle, size: 18),
                title: TextFormField(
                  initialValue: scene.data.title,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                  ),
                  onChanged: (v) =>
                      notifier.updateSceneTitle(actIndex, sceneIndex, v),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: act.scenes.length > 1
                      ? () => notifier.removeScene(actIndex, sceneIndex)
                      : null,
                ),
              );
            },
          ),
          TextButton.icon(
            onPressed: () => notifier.addScene(actIndex),
            icon: const Icon(Icons.add, size: 18),
            label: const Text('添加场次'),
          ),
        ],
      ),
    );
  }
}

class _DrawingStep extends ConsumerWidget {
  const _DrawingStep({required this.state, required this.notifier});

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
        DropdownButtonFormField<int>(
          value: actIndex,
          decoration: const InputDecoration(labelText: '选择幕'),
          items: manifest.acts.asMap().entries.map((e) {
            return DropdownMenuItem(
              value: e.key,
              child: Text(e.value.data.title),
            );
          }).toList(),
          onChanged: (v) {
            if (v != null) notifier.selectScene(v, 0);
          },
        ),
        const SizedBox(height: AppSpacing.md),
        DropdownButtonFormField<int>(
          value: sceneIndex,
          decoration: const InputDecoration(labelText: '选择场次'),
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
          '${scene.data.title} · ${scene.frames.length} 帧',
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            ...scene.frames.asMap().entries.map((entry) {
              final frame = entry.value;
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
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Icon(Icons.add),
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

class _ParamsStep extends StatelessWidget {
  const _ParamsStep({required this.state, required this.notifier});

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

    if (items.isEmpty) {
      return const Text('请先在分镜绘制步骤中添加帧');
    }

    return Column(
      children: items.map((item) {
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.frame.data.title,
                    style: Theme.of(context).textTheme.titleSmall),
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
          ),
        );
      }).toList(),
    );
  }
}

class _ReviewStep extends ConsumerWidget {
  const _ReviewStep({required this.manifest});

  final ScreenplayDraftManifest manifest;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: ref.read(draftStorageServiceProvider).draftRootFor(manifest.draftId),
      builder: (context, snapshot) {
        final tree = const ToDisplayTreeMapper()(
          manifest,
          draftRoot: snapshot.data,
        );
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tree.title,
                style: Theme.of(context).textTheme.headlineSmall),
            if (tree.summary.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(tree.summary),
            ],
            const SizedBox(height: AppSpacing.lg),
            ...tree.acts.map(
              (act) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: Text('${act.title} · ${act.scenes.length} 场'),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _PublishStep extends StatelessWidget {
  const _PublishStep({required this.state});

  final CreateWizardState state;

  @override
  Widget build(BuildContext context) {
    final progress = state.uploadProgress;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('确认发布后，剧本将上传至云端。'),
        const SizedBox(height: AppSpacing.lg),
        if (state.isUploading && progress != null) ...[
          LinearProgressIndicator(value: progress.fraction),
          const SizedBox(height: AppSpacing.sm),
          Text(progress.message),
        ],
        if (!state.isUploading)
          Text(
            '标题：${state.manifest?.screenplay.data.title ?? ''}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
      ],
    );
  }
}
