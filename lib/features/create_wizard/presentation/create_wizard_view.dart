import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/providers/create_wizard_provider.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/theme/wizard_colors.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/widgets/steps/wizard_basic_info_step.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/widgets/steps/wizard_characters_step.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/widgets/steps/wizard_drawing_step.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/widgets/steps/wizard_params_step.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/widgets/steps/wizard_publish_step.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/widgets/steps/wizard_structure_step.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/widgets/wizard_header.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/widgets/wizard_step_progress.dart';
import 'package:rc0_flutter/shared/widgets/app_bottom_inset.dart';
import 'package:rc0_flutter/shared/widgets/app_primary_button.dart';

class CreateWizardView extends ConsumerWidget {
  const CreateWizardView({super.key, this.draftId});

  final String? draftId;

  static const stepTitles = [
    '基本信息',
    '结构',
    '画面',
    '参数',
    '角色',
    '发布',
  ];

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
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.manifest == null
          ? Center(child: Text(state.error ?? '加载失败'))
          : Column(
              children: [
                WizardHeader(onClose: () => context.pop()),
                WizardStepProgress(
                  currentStep: state.currentStep,
                  labels: CreateWizardView.stepTitles,
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.lg,
                    ),
                    children: [
                      _StepBody(state: state, notifier: notifier),
                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
                AppBottomInset(
                  color: AppColors.surface,
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: _BottomActions(
                    state: state,
                    notifier: notifier,
                  ),
                ),
              ],
            ),
    );
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
      1 => WizardBasicInfoStep(manifest: manifest, notifier: notifier),
      2 => WizardStructureStep(manifest: manifest, notifier: notifier),
      3 => WizardDrawingStep(state: state, notifier: notifier),
      4 => WizardParamsStep(state: state, notifier: notifier),
      5 => WizardCharactersStep(manifest: manifest, notifier: notifier),
      6 => WizardPublishStep(
          state: state,
          onPublishLocal: () => _publishLocal(context),
          onPublishCloud: () => _publishCloud(context),
        ),
      _ => const SizedBox.shrink(),
    };
  }

  Future<void> _publishLocal(BuildContext context) async {
    final published = await notifier.publishLocal();
    if (published != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('本地发布成功')),
      );
      context.go(AppRoutes.screenplayDetailPath(published.draftId));
      return;
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error ?? '本地发布失败，请重试')),
      );
    }
  }

  Future<void> _publishCloud(BuildContext context) async {
    final synced = await notifier.publish();
    if (synced != null && context.mounted) {
      final remoteId = synced.screenplay.remoteId;
      if (remoteId != null) {
        context.go(AppRoutes.screenplayDetailPath('$remoteId'));
      } else {
        context.go(AppRoutes.screenplayDetailPath(synced.draftId));
      }
      return;
    }
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('云端同步失败，请重试')),
      );
    }
  }
}

class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.state, required this.notifier});

  final CreateWizardState state;
  final CreateWizardNotifier notifier;

  @override
  Widget build(BuildContext context) {
    final isLastStep = state.currentStep == CreateWizardState.totalSteps;
    if (isLastStep) {
      return const SizedBox.shrink();
    }

    final isBusy = state.isSaving || state.isUploading;
    return AppPrimaryButton(
      label: '下一步',
      backgroundColor: WizardColors.stepActive,
      onPressed: isBusy ? null : () => notifier.nextStep(),
    );
  }
}
