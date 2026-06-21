import 'package:rc0_flutter/features/cine_preset/data/datasources/cine_preset_datasource.dart';
import 'package:rc0_flutter/features/cine_preset/domain/entities/cine_preset.dart';
import 'package:rc0_flutter/features/cine_preset/domain/repositories/cine_preset_repository.dart';

class CinePresetRepositoryImpl implements CinePresetRepository {
  const CinePresetRepositoryImpl(this._datasource);

  final CinePresetDatasource _datasource;

  @override
  Future<List<CinePresetItem>> getPresets(String templateId) =>
      _datasource.getPresets(templateId);

  @override
  Future<CinePresetDetail> getPresetDetail(String templateId, String presetId) =>
      _datasource.getPresetDetail(templateId, presetId);
}
