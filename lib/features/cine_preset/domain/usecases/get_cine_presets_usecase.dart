import 'package:rc0_flutter/features/cine_preset/domain/entities/cine_preset.dart';
import 'package:rc0_flutter/features/cine_preset/domain/repositories/cine_preset_repository.dart';

class GetCinePresetsUseCase {
  const GetCinePresetsUseCase(this._repository);

  final CinePresetRepository _repository;

  Future<List<CinePresetItem>> call(String templateId) =>
      _repository.getPresets(templateId);
}

class GetCinePresetDetailUseCase {
  const GetCinePresetDetailUseCase(this._repository);

  final CinePresetRepository _repository;

  Future<CinePresetDetail> call(String templateId, String presetId) =>
      _repository.getPresetDetail(templateId, presetId);
}
