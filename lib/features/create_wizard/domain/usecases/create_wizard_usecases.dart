import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/services/draft_storage_service.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/services/screenplay_sync_service.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/screenplay_draft_manifest.dart';

class LoadDraftUseCase {
  const LoadDraftUseCase(this._storage);

  final DraftStorageService _storage;

  Future<Result<ScreenplayDraftManifest>> call(String draftId) async {
    try {
      final manifest = await _storage.load(draftId);
      return Success(manifest);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}

class SaveDraftUseCase {
  const SaveDraftUseCase(this._storage);

  final DraftStorageService _storage;

  Future<Result<ScreenplayDraftManifest>> call(
    ScreenplayDraftManifest manifest,
  ) async {
    try {
      await _storage.save(manifest);
      final saved = await _storage.load(manifest.draftId);
      return Success(saved);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}

class CreateDraftUseCase {
  const CreateDraftUseCase(this._storage);

  final DraftStorageService _storage;

  Future<Result<ScreenplayDraftManifest>> call() async {
    try {
      final manifest = await _storage.create();
      return Success(manifest);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}

class UploadDraftUseCase {
  const UploadDraftUseCase(this._sync);

  final ScreenplaySyncService _sync;

  Future<Result<ScreenplayDraftManifest>> call(
    ScreenplayDraftManifest manifest, {
    void Function(UploadProgress progress)? onProgress,
  }) async {
    try {
      final synced = await _sync.upload(manifest, onProgress: onProgress);
      return Success(synced);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}

class PublishLocalDraftUseCase {
  const PublishLocalDraftUseCase(this._storage);

  final DraftStorageService _storage;

  Future<Result<ScreenplayDraftManifest>> call(
    ScreenplayDraftManifest manifest,
  ) async {
    try {
      final now = DateTime.now().toUtc();
      final updated = manifest.copyWith(
        screenplay: manifest.screenplay.copyWith(
          localModifiedAt: now,
          data: manifest.screenplay.data.copyWith(publishStatus: 1),
        ),
        sync: manifest.sync.copyWith(
          lastLocalSaveAt: now,
          pendingUpload: manifest.screenplay.remoteId == null,
        ),
      );
      await _storage.save(updated);
      final saved = await _storage.load(updated.draftId);
      return Success(saved);
    } catch (e) {
      return Failure(Exception(e.toString()));
    }
  }
}
