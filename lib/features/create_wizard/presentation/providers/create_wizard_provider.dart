import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/create_wizard/domain/usecases/create_wizard_usecases.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/providers/create_wizard_repository_provider.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/services/screenplay_sync_service.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_asset.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/enums/sync_state.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_nodes.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/screenplay_draft_manifest.dart';

class CreateWizardState {
  const CreateWizardState({
    this.manifest,
    this.currentStep = 1,
    this.isLoading = false,
    this.isSaving = false,
    this.isUploading = false,
    this.uploadProgress,
    this.error,
    this.selectedActIndex = 0,
    this.selectedSceneIndex = 0,
  });

  static const totalSteps = 6;

  final ScreenplayDraftManifest? manifest;
  final int currentStep;
  final bool isLoading;
  final bool isSaving;
  final bool isUploading;
  final UploadProgress? uploadProgress;
  final String? error;
  final int selectedActIndex;
  final int selectedSceneIndex;

  CreateWizardState copyWith({
    ScreenplayDraftManifest? manifest,
    int? currentStep,
    bool? isLoading,
    bool? isSaving,
    bool? isUploading,
    UploadProgress? uploadProgress,
    String? error,
    int? selectedActIndex,
    int? selectedSceneIndex,
  }) {
    return CreateWizardState(
      manifest: manifest ?? this.manifest,
      currentStep: currentStep ?? this.currentStep,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      isUploading: isUploading ?? this.isUploading,
      uploadProgress: uploadProgress ?? this.uploadProgress,
      error: error,
      selectedActIndex: selectedActIndex ?? this.selectedActIndex,
      selectedSceneIndex: selectedSceneIndex ?? this.selectedSceneIndex,
    );
  }
}

class CreateWizardNotifier extends StateNotifier<CreateWizardState> {
  CreateWizardNotifier(
    this._loadDraft,
    this._saveDraft,
    this._createDraft,
    this._uploadDraft, {
    String? draftId,
  }) : super(const CreateWizardState()) {
    _init(draftId);
  }

  final LoadDraftUseCase _loadDraft;
  final SaveDraftUseCase _saveDraft;
  final CreateDraftUseCase _createDraft;
  final UploadDraftUseCase _uploadDraft;

  Future<void> _init(String? draftId) async {
    state = state.copyWith(isLoading: true, error: null);
    final result = draftId != null
        ? await _loadDraft(draftId)
        : await _createDraft();
    if (result is Failure<ScreenplayDraftManifest>) {
      state = state.copyWith(
        isLoading: false,
        error: result.exception.toString(),
      );
      return;
    }
    state = state.copyWith(
      manifest: (result as Success<ScreenplayDraftManifest>).data,
      isLoading: false,
    );
  }

  Future<void> _persist() async {
    final manifest = state.manifest;
    if (manifest == null) return;
    state = state.copyWith(isSaving: true);
    final result = await _saveDraft(manifest);
    state = state.copyWith(isSaving: false);
    if (result is Success<ScreenplayDraftManifest>) {
      state = state.copyWith(manifest: result.data);
    }
  }

  Future<void> nextStep() async {
    await _persist();
    if (state.currentStep < CreateWizardState.totalSteps) {
      state = state.copyWith(currentStep: state.currentStep + 1);
    }
  }

  Future<void> previousStep() async {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  void updateTitle(String title) => _updateManifest((m) {
    final now = DateTime.now().toUtc();
    return m.copyWith(
      screenplay: m.screenplay.copyWith(
        localModifiedAt: now,
        data: m.screenplay.data.copyWith(title: title),
      ),
    );
  });

  void updateSubtitle(String subtitle) => _updateManifest((m) {
    final now = DateTime.now().toUtc();
    return m.copyWith(
      screenplay: m.screenplay.copyWith(
        localModifiedAt: now,
        data: m.screenplay.data.copyWith(subtitle: subtitle),
      ),
    );
  });

  void updateSummary(String summary) => _updateManifest((m) {
    final now = DateTime.now().toUtc();
    return m.copyWith(
      screenplay: m.screenplay.copyWith(
        localModifiedAt: now,
        data: m.screenplay.data.copyWith(summary: summary),
      ),
    );
  });

  Future<void> setCoverFromFile(File file, String assetRef, String relativePath) async {
    final m = state.manifest;
    if (m == null) return;
    final now = DateTime.now().toUtc();
    final assets = Map<String, DraftAsset>.from(m.assets);
    assets[assetRef] = DraftAsset(
      ref: assetRef,
      kind: DraftAssetKind.cover,
      localUri: relativePath,
      syncState: AssetSyncState.localOnly,
    );
    _updateManifest((manifest) => manifest.copyWith(
      assets: assets,
      screenplay: manifest.screenplay.copyWith(
        localModifiedAt: now,
        data: manifest.screenplay.data.copyWith(coverAssetRef: assetRef),
      ),
    ));
    await _persist();
  }

  void addAct() => _updateManifest((m) {
    final now = DateTime.now().toUtc();
    final sort = m.acts.length + 1;
    return m.copyWith(
      acts: [
        ...m.acts,
        DraftAct(
          localId: 'act-${DateTime.now().microsecondsSinceEpoch}',
          localModifiedAt: now,
          data: DraftActData(title: '第 $sort 幕', sort: sort),
          scenes: [
            DraftScene(
              localId: 'scene-${DateTime.now().microsecondsSinceEpoch}',
              localModifiedAt: now,
              data: const DraftSceneData(title: '场次 1', sort: 1),
            ),
          ],
        ),
      ],
    );
  });

  void addScene(int actIndex) => _updateManifest((m) {
    if (actIndex < 0 || actIndex >= m.acts.length) return m;
    final now = DateTime.now().toUtc();
    final act = m.acts[actIndex];
    final sort = act.scenes.length + 1;
    final scenes = [
      ...act.scenes,
      DraftScene(
        localId: 'scene-${DateTime.now().microsecondsSinceEpoch}',
        localModifiedAt: now,
        data: DraftSceneData(title: '场次 $sort', sort: sort),
      ),
    ];
    final acts = List<DraftAct>.from(m.acts);
    acts[actIndex] = act.copyWith(scenes: scenes, localModifiedAt: now);
    return m.copyWith(acts: acts);
  });

  void removeScene(int actIndex, int sceneIndex) => _updateManifest((m) {
    if (actIndex < 0 || actIndex >= m.acts.length) return m;
    final act = m.acts[actIndex];
    if (sceneIndex < 0 || sceneIndex >= act.scenes.length) return m;
    final scenes = List<DraftScene>.from(act.scenes)..removeAt(sceneIndex);
    final acts = List<DraftAct>.from(m.acts);
    acts[actIndex] = act.copyWith(
      scenes: scenes,
      localModifiedAt: DateTime.now().toUtc(),
    );
    return m.copyWith(acts: acts);
  });

  void updateSceneTitle(int actIndex, int sceneIndex, String title) =>
      _updateManifest((m) {
        if (actIndex < 0 || actIndex >= m.acts.length) return m;
        final act = m.acts[actIndex];
        if (sceneIndex < 0 || sceneIndex >= act.scenes.length) return m;
        final scenes = List<DraftScene>.from(act.scenes);
        final scene = scenes[sceneIndex];
        scenes[sceneIndex] = scene.copyWith(
          localModifiedAt: DateTime.now().toUtc(),
          data: scene.data.copyWith(title: title),
        );
        final acts = List<DraftAct>.from(m.acts);
        acts[actIndex] = act.copyWith(scenes: scenes);
        return m.copyWith(acts: acts);
      });

  void reorderScenes(int actIndex, int oldIndex, int newIndex) =>
      _updateManifest((m) {
        if (actIndex < 0 || actIndex >= m.acts.length) return m;
        final act = m.acts[actIndex];
        final scenes = List<DraftScene>.from(act.scenes);
        if (oldIndex < newIndex) newIndex -= 1;
        final item = scenes.removeAt(oldIndex);
        scenes.insert(newIndex, item);
        for (var i = 0; i < scenes.length; i++) {
          scenes[i] = scenes[i].copyWith(
            data: scenes[i].data.copyWith(sort: i + 1),
          );
        }
        final acts = List<DraftAct>.from(m.acts);
        acts[actIndex] = act.copyWith(scenes: scenes);
        return m.copyWith(acts: acts);
      });

  void selectScene(int actIndex, int sceneIndex) {
    state = state.copyWith(
      selectedActIndex: actIndex,
      selectedSceneIndex: sceneIndex,
    );
  }

  Future<void> addFrameFromFile(
    int actIndex,
    int sceneIndex,
    File file,
    String assetRef,
    String relativePath,
  ) async {
    final m = state.manifest;
    if (m == null) return;
    if (actIndex < 0 || actIndex >= m.acts.length) return;
    final act = m.acts[actIndex];
    if (sceneIndex < 0 || sceneIndex >= act.scenes.length) return;
    final scene = act.scenes[sceneIndex];
    final now = DateTime.now().toUtc();
    final sort = scene.frames.length + 1;
    final frameLocalId = 'frame-${DateTime.now().microsecondsSinceEpoch}';

    final assets = Map<String, DraftAsset>.from(m.assets);
    assets[assetRef] = DraftAsset(
      ref: assetRef,
      kind: DraftAssetKind.frameImage,
      localUri: relativePath,
      syncState: AssetSyncState.localOnly,
    );

    final frame = DraftFrame(
      localId: frameLocalId,
      localModifiedAt: now,
      data: DraftFrameData(
        title: '帧 $sort',
        sort: sort,
        imageAssetRef: assetRef,
        durationSec: 3,
      ),
    );

    final scenes = List<DraftScene>.from(act.scenes);
    scenes[sceneIndex] = scene.copyWith(
      frames: [...scene.frames, frame],
      localModifiedAt: now,
    );
    final acts = List<DraftAct>.from(m.acts);
    acts[actIndex] = act.copyWith(scenes: scenes);

    state = state.copyWith(
      manifest: m.copyWith(assets: assets, acts: acts),
    );
    await _persist();
  }

  void updateFrameParams(
    int actIndex,
    int sceneIndex,
    int frameIndex, {
    String? aspectRatio,
    String? shotType,
    int? cinePresetId,
    int? durationSec,
  }) => _updateManifest((m) {
    if (actIndex < 0 || actIndex >= m.acts.length) return m;
    final act = m.acts[actIndex];
    if (sceneIndex < 0 || sceneIndex >= act.scenes.length) return m;
    final scene = act.scenes[sceneIndex];
    if (frameIndex < 0 || frameIndex >= scene.frames.length) return m;
    final frames = List<DraftFrame>.from(scene.frames);
    final frame = frames[frameIndex];
    frames[frameIndex] = frame.copyWith(
      localModifiedAt: DateTime.now().toUtc(),
      data: frame.data.copyWith(
        aspectRatio: aspectRatio,
        shotType: shotType,
        cinePresetId: cinePresetId,
        durationSec: durationSec,
      ),
    );
    final scenes = List<DraftScene>.from(act.scenes);
    scenes[sceneIndex] = scene.copyWith(frames: frames);
    final acts = List<DraftAct>.from(m.acts);
    acts[actIndex] = act.copyWith(scenes: scenes);
    return m.copyWith(acts: acts);
  });

  Future<ScreenplayDraftManifest?> publish() async {
    final manifest = state.manifest;
    if (manifest == null) return null;
    await _persist();
    state = state.copyWith(isUploading: true, uploadProgress: null);
    final result = await _uploadDraft(
      manifest,
      onProgress: (p) => state = state.copyWith(uploadProgress: p),
    );
    state = state.copyWith(isUploading: false);
    if (result is Failure<ScreenplayDraftManifest>) {
      state = state.copyWith(error: result.exception.toString());
      return null;
    }
    final synced = (result as Success<ScreenplayDraftManifest>).data;
    state = state.copyWith(manifest: synced);
    return synced;
  }

  void _updateManifest(
    ScreenplayDraftManifest Function(ScreenplayDraftManifest) updater,
  ) {
    final m = state.manifest;
    if (m == null) return;
    state = state.copyWith(manifest: updater(m));
  }
}

final createWizardProvider =
    StateNotifierProvider<CreateWizardNotifier, CreateWizardState>((ref) {
  return CreateWizardNotifier(
    ref.watch(loadDraftUseCaseProvider),
    ref.watch(saveDraftUseCaseProvider),
    ref.watch(createDraftUseCaseProvider),
    ref.watch(uploadDraftUseCaseProvider),
  );
});

final createWizardFamilyProvider = StateNotifierProvider.family<
    CreateWizardNotifier, CreateWizardState, String?>((ref, draftId) {
  return CreateWizardNotifier(
    ref.watch(loadDraftUseCaseProvider),
    ref.watch(saveDraftUseCaseProvider),
    ref.watch(createDraftUseCaseProvider),
    ref.watch(uploadDraftUseCaseProvider),
    draftId: draftId,
  );
});
