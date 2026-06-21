import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/create_wizard_view.dart';

class CreateWizardPage extends ConsumerWidget {
  const CreateWizardPage({super.key, this.draftId});

  final String? draftId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CreateWizardView(draftId: draftId);
  }
}
