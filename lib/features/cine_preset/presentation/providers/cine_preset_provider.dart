import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/features/cine_preset/data/datasources/cine_preset_datasource.dart';
import 'package:rc0_flutter/features/cine_preset/data/datasources/remote_cine_preset_datasource.dart';
import 'package:rc0_flutter/features/cine_preset/data/repositories/cine_preset_repository_impl.dart';
import 'package:rc0_flutter/features/cine_preset/domain/entities/cine_preset.dart';
import 'package:rc0_flutter/features/cine_preset/domain/repositories/cine_preset_repository.dart';
import 'package:rc0_flutter/features/cine_preset/domain/usecases/get_cine_presets_usecase.dart';

final cinePresetDatasourceProvider = Provider<CinePresetDatasource>(
  (ref) => RemoteCinePresetDatasource(ref.watch(dioClientProvider)),
);

final cinePresetRepositoryProvider = Provider<CinePresetRepository>((ref) {
  return CinePresetRepositoryImpl(ref.watch(cinePresetDatasourceProvider));
});

final getCinePresetsUseCaseProvider = Provider<GetCinePresetsUseCase>((ref) {
  return GetCinePresetsUseCase(ref.watch(cinePresetRepositoryProvider));
});

final getCinePresetDetailUseCaseProvider = Provider<GetCinePresetDetailUseCase>((
  ref,
) {
  return GetCinePresetDetailUseCase(ref.watch(cinePresetRepositoryProvider));
});

class CinePresetState {
  const CinePresetState({
    this.presets = const [],
    this.selectedPresetId,
    this.detail,
    this.isLoading = false,
    this.error,
  });

  final List<CinePresetItem> presets;
  final String? selectedPresetId;
  final CinePresetDetail? detail;
  final bool isLoading;
  final String? error;

  CinePresetState copyWith({
    List<CinePresetItem>? presets,
    String? selectedPresetId,
    CinePresetDetail? detail,
    bool? isLoading,
    String? error,
  }) {
    return CinePresetState(
      presets: presets ?? this.presets,
      selectedPresetId: selectedPresetId ?? this.selectedPresetId,
      detail: detail ?? this.detail,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class CinePresetNotifier extends StateNotifier<CinePresetState> {
  CinePresetNotifier(this._getPresets, this._getDetail, this._templateId)
    : super(const CinePresetState()) {
    load();
  }

  final GetCinePresetsUseCase _getPresets;
  final GetCinePresetDetailUseCase _getDetail;
  final String _templateId;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final presets = await _getPresets(_templateId);
      if (presets.isEmpty) {
        state = state.copyWith(isLoading: false, presets: []);
        return;
      }
      final selectedId = presets.firstWhere((p) => p.isSelected, orElse: () => presets.first).id;
      final detail = await _getDetail(_templateId, selectedId);
      state = state.copyWith(
        presets: presets,
        selectedPresetId: selectedId,
        detail: detail,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> selectPreset(String presetId) async {
    state = state.copyWith(selectedPresetId: presetId);
    final detail = await _getDetail(_templateId, presetId);
    state = state.copyWith(detail: detail);
  }
}

final cinePresetProvider = StateNotifierProvider.family<
    CinePresetNotifier, CinePresetState, String>((ref, templateId) {
  return CinePresetNotifier(
    ref.watch(getCinePresetsUseCaseProvider),
    ref.watch(getCinePresetDetailUseCaseProvider),
    templateId,
  );
});
