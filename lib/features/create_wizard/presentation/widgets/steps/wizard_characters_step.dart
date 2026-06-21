import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/providers/create_wizard_provider.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/widgets/wizard_header.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/mappers/to_display_tree_mapper.dart';
import 'package:rc0_flutter/features/screenplay/presentation/providers/screenplay_providers.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/screenplay_draft_manifest.dart';

class WizardCharactersStep extends ConsumerStatefulWidget {
  const WizardCharactersStep({
    super.key,
    required this.manifest,
    required this.notifier,
  });

  final ScreenplayDraftManifest manifest;
  final CreateWizardNotifier notifier;

  @override
  ConsumerState<WizardCharactersStep> createState() =>
      _WizardCharactersStepState();
}

class _WizardCharactersStepState extends ConsumerState<WizardCharactersStep> {
  late final TextEditingController _authorController;

  @override
  void initState() {
    super.initState();
    _authorController = TextEditingController(
      text: widget.manifest.authorName ?? '',
    );
  }

  @override
  void dispose() {
    _authorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref.read(draftStorageServiceProvider).draftRootFor(
        widget.manifest.draftId,
      ),
      builder: (context, snapshot) {
        final tree = const ToDisplayTreeMapper()(
          widget.manifest,
          draftRoot: snapshot.data,
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const WizardSectionHeader(title: '角色'),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: '创作者署名',
                hintText: '可选，展示在剧本详情页',
              ),
              onChanged: (value) => widget.notifier.updateAuthorName(value),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '结构预览',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(tree.title),
            if (tree.summary.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(tree.summary),
            ],
            const SizedBox(height: AppSpacing.md),
            ...tree.acts.map(
              (act) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text('${act.title} · ${act.scenes.length} 场'),
              ),
            ),
          ],
        );
      },
    );
  }
}
