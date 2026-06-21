import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/create_wizard/domain/entities/wizard_act.dart';
import 'package:rc0_flutter/features/create_wizard/domain/repositories/create_wizard_repository.dart';

class GetWizardActsUseCase {
  const GetWizardActsUseCase(this._repository);

  final CreateWizardRepository _repository;

  Future<Result<List<WizardAct>>> call() async {
    try {
      final acts = await _repository.getInitialActs();
      return Success(acts);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
