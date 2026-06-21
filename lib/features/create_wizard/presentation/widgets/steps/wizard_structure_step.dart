import 'package:flutter/material.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/providers/create_wizard_provider.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/theme/wizard_colors.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/widgets/wizard_header.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_nodes.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/screenplay_draft_manifest.dart';

class WizardStructureStep extends StatefulWidget {
  const WizardStructureStep({
    super.key,
    required this.manifest,
    required this.notifier,
  });

  final ScreenplayDraftManifest manifest;
  final CreateWizardNotifier notifier;

  @override
  State<WizardStructureStep> createState() => _WizardStructureStepState();
}

class _WizardStructureStepState extends State<WizardStructureStep> {
  late Set<int> _expandedActs;

  @override
  void initState() {
    super.initState();
    _expandedActs = widget.manifest.acts.isEmpty ? {} : {0};
  }

  @override
  void didUpdateWidget(covariant WizardStructureStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.manifest.acts.length > oldWidget.manifest.acts.length) {
      _expandedActs.add(widget.manifest.acts.length - 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const WizardSectionHeader(title: '结构搭建'),
        const SizedBox(height: AppSpacing.lg),
        ...widget.manifest.acts.asMap().entries.map((entry) {
          final actIndex = entry.key;
          final act = entry.value;
          final expanded = _expandedActs.contains(actIndex);
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: _ActSection(
              actIndex: actIndex,
              act: act,
              expanded: expanded,
              onToggle: () {
                setState(() {
                  if (expanded) {
                    _expandedActs.remove(actIndex);
                  } else {
                    _expandedActs.add(actIndex);
                  }
                });
              },
              notifier: widget.notifier,
            ),
          );
        }),
        _AddActButton(onPressed: widget.notifier.addAct),
      ],
    );
  }
}

class _ActSection extends StatelessWidget {
  const _ActSection({
    required this.actIndex,
    required this.act,
    required this.expanded,
    required this.onToggle,
    required this.notifier,
  });

  final int actIndex;
  final DraftAct act;
  final bool expanded;
  final VoidCallback onToggle;
  final CreateWizardNotifier notifier;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Row(
              children: [
                Text(
                  'Act ${actIndex + 1} ${act.data.title}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (actIndex == 0) const WizardRequiredBadge(),
                const Spacer(),
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  icon: const Icon(Icons.tune, size: 18, color: AppColors.textSecondary),
                  onPressed: () => _editActTitle(context),
                ),
                Icon(
                  expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        if (expanded) ...[
          ReorderableListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: act.scenes.length,
            onReorder: (oldIndex, newIndex) =>
                notifier.reorderScenes(actIndex, oldIndex, newIndex),
            itemBuilder: (context, sceneIndex) {
              final scene = act.scenes[sceneIndex];
              return _SceneCard(
                key: ValueKey(scene.localId),
                sceneIndex: sceneIndex,
                title: scene.data.title,
                onTitleChanged: (value) =>
                    notifier.updateSceneTitle(actIndex, sceneIndex, value),
                onDelete: act.scenes.length > 1
                    ? () => notifier.removeScene(actIndex, sceneIndex)
                    : null,
              );
            },
          ),
          Center(
            child: TextButton(
              onPressed: () => notifier.addScene(actIndex),
              child: const Text(
                '+ 添加场景',
                style: TextStyle(
                  color: WizardColors.linkAction,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Future<void> _editActTitle(BuildContext context) async {
    final controller = TextEditingController(text: act.data.title);
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('编辑 Act ${actIndex + 1}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: '幕标题'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('确定'),
          ),
        ],
      ),
    );
    if (result != null && result.isNotEmpty) {
      notifier.updateActTitle(actIndex, result);
    }
  }
}

class _SceneCard extends StatelessWidget {
  const _SceneCard({
    super.key,
    required this.sceneIndex,
    required this.title,
    required this.onTitleChanged,
    this.onDelete,
  });

  final int sceneIndex;
  final String title;
  final ValueChanged<String> onTitleChanged;
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: WizardColors.sceneCardBackground,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              initialValue: title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: onTitleChanged,
            ),
          ),
          ReorderableDragStartListener(
            index: sceneIndex,
            child: const Icon(
              Icons.drag_indicator,
              size: 20,
              color: AppColors.textHint,
            ),
          ),
          if (onDelete != null) ...[
            const SizedBox(width: AppSpacing.xs),
            InkWell(
              onTap: onDelete,
              child: const Icon(
                Icons.close,
                size: 18,
                color: AppColors.textHint,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _AddActButton extends StatelessWidget {
  const _AddActButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: WizardColors.addActBackground,
          foregroundColor: WizardColors.addActForeground,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
        ),
        child: const Text(
          '+ 添加 Act',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
