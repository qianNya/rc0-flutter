import 'package:flutter/material.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/theme/wizard_colors.dart';

class WizardStepProgress extends StatelessWidget {
  const WizardStepProgress({
    super.key,
    required this.currentStep,
    required this.labels,
  });

  final int currentStep;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final step = index + 1;
          final isActive = step == currentStep;
          final isCompleted = step < currentStep;
          final activeColor = isActive || isCompleted
              ? WizardColors.stepActive
              : WizardColors.stepInactive;
          final labelColor = isActive
              ? WizardColors.stepActive
              : WizardColors.stepLabelInactive;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: step <= currentStep
                              ? WizardColors.stepActive
                              : WizardColors.stepInactive,
                        ),
                      ),
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: activeColor,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$step',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isActive || isCompleted
                              ? Colors.white
                              : WizardColors.stepLabelInactive,
                        ),
                      ),
                    ),
                    if (index < labels.length - 1)
                      Expanded(
                        child: Container(
                          height: 2,
                          color: step < currentStep
                              ? WizardColors.stepActive
                              : WizardColors.stepInactive,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  labels[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                    color: labelColor,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
