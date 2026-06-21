import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/providers/create_wizard_provider.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/widgets/wizard_header.dart';
import 'package:rc0_flutter/features/screenplay/presentation/providers/screenplay_providers.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_asset.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/screenplay_draft_manifest.dart';
import 'package:rc0_flutter/shared/widgets/draft_image.dart';

class WizardBasicInfoStep extends ConsumerStatefulWidget {
  const WizardBasicInfoStep({
    super.key,
    required this.manifest,
    required this.notifier,
  });

  final ScreenplayDraftManifest manifest;
  final CreateWizardNotifier notifier;

  @override
  ConsumerState<WizardBasicInfoStep> createState() =>
      _WizardBasicInfoStepState();
}

class _WizardBasicInfoStepState extends ConsumerState<WizardBasicInfoStep> {
  late final TextEditingController _titleController;
  late final TextEditingController _subtitleController;
  late final TextEditingController _summaryController;

  @override
  void initState() {
    super.initState();
    final data = widget.manifest.screenplay.data;
    _titleController = TextEditingController(text: data.title);
    _subtitleController = TextEditingController(text: data.subtitle);
    _summaryController = TextEditingController(text: data.summary);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storage = ref.watch(draftStorageServiceProvider);
    final coverRef = widget.manifest.screenplay.data.coverAssetRef;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardSectionHeader(title: '基本信息'),
        const SizedBox(height: AppSpacing.lg),
        GestureDetector(
          onTap: () => _pickCover(storage),
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
                      future: storage.draftRootFor(widget.manifest.draftId),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        final asset = widget.manifest.assets[coverRef];
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
          controller: _titleController,
          decoration: const InputDecoration(labelText: '标题'),
          onChanged: widget.notifier.updateTitle,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _subtitleController,
          decoration: const InputDecoration(labelText: '副标题'),
          onChanged: widget.notifier.updateSubtitle,
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _summaryController,
          decoration: const InputDecoration(labelText: '简介'),
          maxLines: 3,
          onChanged: widget.notifier.updateSummary,
        ),
      ],
    );
  }

  Future<void> _pickCover(dynamic storage) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final assetRef = storage.newAssetRef('cover');
    final rel = await storage.registerLocalAsset(
      draftId: widget.manifest.draftId,
      assetRef: assetRef,
      kind: DraftAssetKind.cover,
      sourceFile: File(picked.path),
      relativePath: 'assets/cover.jpg',
    );
    await widget.notifier.setCoverFromFile(File(picked.path), assetRef, rel);
  }
}
