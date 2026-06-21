import 'package:rc0_flutter/features/cine_preset/domain/entities/cine_preset.dart';

abstract class CinePresetRepository {
  Future<List<CinePresetItem>> getPresets(String templateId);
  Future<CinePresetDetail> getPresetDetail(String templateId, String presetId);
}
