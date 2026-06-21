import 'package:rc0_flutter/features/screenplay/data/datasources/screenplay_datasource.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/mappers/to_create_payload_mapper.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/services/draft_storage_service.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_asset.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_nodes.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/screenplay_draft_manifest.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/enums/sync_state.dart';

class UploadProgress {
  const UploadProgress({
    required this.step,
    required this.totalSteps,
    this.message = '',
  });

  final int step;
  final int totalSteps;
  final String message;

  double get fraction => totalSteps > 0 ? step / totalSteps : 0;
}

class ScreenplaySyncService {
  ScreenplaySyncService({
    required ScreenplayDatasource datasource,
    required DraftStorageService storage,
    ToCreatePayloadMapper? payloadMapper,
  }) : _datasource = datasource,
       _storage = storage,
       _payloadMapper = payloadMapper ?? const ToCreatePayloadMapper();

  final ScreenplayDatasource _datasource;
  final DraftStorageService _storage;
  final ToCreatePayloadMapper _payloadMapper;

  Future<ScreenplayDraftManifest> upload(
    ScreenplayDraftManifest manifest, {
    void Function(UploadProgress progress)? onProgress,
  }) async {
    final draftRoot = await _storage.draftRootFor(manifest.draftId);
    var current = manifest;
    var step = 0;
    var totalSteps = _estimateTotalSteps(current);

    void report(String message) {
      onProgress?.call(UploadProgress(
        step: step,
        totalSteps: totalSteps,
        message: message,
      ));
    }

    report('创建剧本...');
    var screenplayRemoteId = current.screenplay.remoteId ?? 0;
    if (screenplayRemoteId == 0) {
      final created = await _datasource.createScreenplay(
        _payloadMapper.screenplayPayload(current),
      );
      screenplayRemoteId = created.id;
      current = current.copyWith(
        screenplay: current.screenplay.copyWith(
          remoteId: screenplayRemoteId,
          remoteUpdateAt: created.updateAt ?? DateTime.now().toUtc(),
        ),
      );
    }
    step++;

    report('上传封面...');
    final coverRef = current.screenplay.data.coverAssetRef;
    if (coverRef != null) {
      final coverAsset = current.assets[coverRef];
      if (coverAsset != null && coverAsset.syncState == AssetSyncState.localOnly) {
        final path = _payloadMapper.localAssetPath(current, coverRef, draftRoot);
        if (path != null) {
          final coverUrl =
              await _datasource.uploadCover(screenplayRemoteId, path);
          final updatedAssets = Map<String, DraftAsset>.from(current.assets);
          updatedAssets[coverRef] = coverAsset.copyWith(
            remoteUrl: coverUrl,
            syncState: AssetSyncState.synced,
            syncedAt: DateTime.now().toUtc(),
          );
          current = current.copyWith(assets: updatedAssets);
        }
      }
      step++;
    }

    final updatedActs = <DraftAct>[];

    for (final act in current.acts) {
      report('上传幕：${act.data.title}');
      var actRemoteId = act.remoteId ?? 0;
      if (actRemoteId == 0) {
        final created = await _datasource.createAct(
          screenplayRemoteId,
          _payloadMapper.actPayload(act),
        );
        actRemoteId = created.id;
      }
      step++;

      final updatedScenes = <DraftScene>[];
      for (final scene in act.scenes) {
        report('上传场：${scene.data.title}');
        var sceneRemoteId = scene.remoteId ?? 0;
        if (sceneRemoteId == 0) {
          final created = await _datasource.createScene(
            screenplayRemoteId,
            actRemoteId,
            _payloadMapper.scenePayload(scene),
          );
          sceneRemoteId = created.id;
        }
        step++;

        final updatedFrames = <DraftFrame>[];
        for (final frame in scene.frames) {
          report('上传帧：${frame.data.title}');
          final imageRef = frame.data.imageAssetRef;
          if (imageRef != null) {
            final asset = current.assets[imageRef];
            if (asset != null && asset.syncState == AssetSyncState.localOnly) {
              final path =
                  _payloadMapper.localAssetPath(current, imageRef, draftRoot);
              if (path != null) {
                final uploaded = await _datasource.uploadImage(path);
                final updatedAssets =
                    Map<String, DraftAsset>.from(current.assets);
                updatedAssets[imageRef] = asset.copyWith(
                  remoteImageId: uploaded.id,
                  remoteImageFileId: uploaded.fileId,
                  remoteUrl: uploaded.url,
                  remoteObjectKey: uploaded.objectKey,
                  syncState: AssetSyncState.synced,
                  syncedAt: DateTime.now().toUtc(),
                );
                current = current.copyWith(assets: updatedAssets);
                step++;
              }
            }
          }

          var frameRemoteId = frame.remoteId ?? 0;
          if (frameRemoteId == 0) {
            final acgnId = imageRef != null
                ? current.assets[imageRef]?.remoteImageId
                : frame.data.acgnImageId;
            final acgnFileId = imageRef != null
                ? current.assets[imageRef]?.remoteImageFileId
                : frame.data.acgnImageFileId;
            final frameWithAsset = frame.copyWith(
              data: frame.data.copyWith(
                acgnImageId: acgnId,
                acgnImageFileId: acgnFileId,
              ),
            );
            final created = await _datasource.createFrame(
              screenplayRemoteId,
              sceneRemoteId,
              _payloadMapper.framePayload(frameWithAsset, current),
            );
            frameRemoteId = created.id;
            updatedFrames.add(
              frameWithAsset.copyWith(
                remoteId: frameRemoteId,
                remoteUpdateAt: created.updateAt ?? DateTime.now().toUtc(),
              ),
            );
          } else {
            updatedFrames.add(frame);
          }
          step++;
        }

        updatedScenes.add(
          scene.copyWith(remoteId: sceneRemoteId, frames: updatedFrames),
        );
      }

      updatedActs.add(
        act.copyWith(remoteId: actRemoteId, scenes: updatedScenes),
      );
    }

    report('发布剧本...');
    if (screenplayRemoteId > 0) {
      await _datasource.updateScreenplay(
        screenplayRemoteId,
        _payloadMapper.screenplayPayload(current),
      );
    }
    await _datasource.publish(screenplayRemoteId);
    step++;

    final now = DateTime.now().toUtc();
    final synced = current.copyWith(
      acts: updatedActs,
      sync: current.sync.copyWith(
        state: SyncState.synced,
        lastRemoteSyncAt: now,
        pendingUpload: false,
      ),
      source: DraftSource(
        type: current.source.type,
        remoteScreenplayId: screenplayRemoteId,
        forkSourceId: current.source.forkSourceId,
      ),
    );

    await _storage.save(synced);
    onProgress?.call(UploadProgress(
      step: totalSteps,
      totalSteps: totalSteps,
      message: '发布完成',
    ));
    return synced;
  }

  int _estimateTotalSteps(ScreenplayDraftManifest manifest) {
    var total = 2; // screenplay + publish
    if (manifest.screenplay.data.coverAssetRef != null) total++;
    for (final act in manifest.acts) {
      total++;
      for (final scene in act.scenes) {
        total++;
        for (final frame in scene.frames) {
          total++;
          final ref = frame.data.imageAssetRef;
          if (ref != null) {
            final asset = manifest.assets[ref];
            if (asset != null && asset.syncState == AssetSyncState.localOnly) {
              total++;
            }
          }
        }
      }
    }
    return total;
  }
}
