import 'package:rc0_flutter/features/create_wizard/domain/entities/wizard_act.dart';

abstract class CreateWizardRepository {
  Future<List<WizardAct>> getInitialActs();
}
