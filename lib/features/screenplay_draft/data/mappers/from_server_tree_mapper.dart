import 'package:rc0_flutter/features/screenplay/data/models/screenplay_tree_dto.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_asset.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_nodes.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/screenplay_draft_manifest.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/enums/draft_source_type.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/enums/sync_state.dart';
import 'package:uuid/uuid.dart';

class FromServerTreeMapper {
  FromServerTreeMapper({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;

  ScreenplayDraftManifest call(ScreenplayTreeDto tree, {String? draftId}) {
    final now = DateTime.now().toUtc();
    final id = draftId ?? _uuid.v4();
    final assets = <String, DraftAsset>{};

    String? coverRef;
    if (tree.screenplay.coverUrl != null &&
        tree.screenplay.coverUrl!.isNotEmpty) {
      coverRef = _registerRemoteAsset(
        assets,
        kind: DraftAssetKind.cover,
        url: tree.screenplay.coverUrl!,
      );
    }

    final acts = tree.acts.map((actDto) {
      return DraftAct(
        localId: 'act-${_uuid.v4()}',
        remoteId: actDto.act.id,
        localModifiedAt: now,
        remoteUpdateAt: actDto.act.updateAt,
        data: DraftActData(
          title: actDto.act.title,
          summary: actDto.act.summary,
          sort: actDto.act.sort,
        ),
        scenes: actDto.scenes.map((sceneDto) {
          return DraftScene(
            localId: 'scene-${_uuid.v4()}',
            remoteId: sceneDto.scene.id,
            localModifiedAt: now,
            remoteUpdateAt: sceneDto.scene.updateAt,
            data: DraftSceneData(
              title: sceneDto.scene.title,
              summary: sceneDto.scene.summary,
              location: sceneDto.scene.location ?? '',
              timeOfDay: sceneDto.scene.timeOfDay ?? '',
              sort: sceneDto.scene.sort,
            ),
            frames: sceneDto.frames.map((frameDto) {
              String? imageRef;
              String? thumbRef;
              if (frameDto.imageUrl != null && frameDto.imageUrl!.isNotEmpty) {
                imageRef = _registerRemoteAsset(
                  assets,
                  kind: DraftAssetKind.frameImage,
                  url: frameDto.imageUrl!,
                  imageId: frameDto.acgnImageId,
                  imageFileId: frameDto.acgnImageFileId,
                );
              }
              if (frameDto.thumbnailUrl != null &&
                  frameDto.thumbnailUrl!.isNotEmpty) {
                thumbRef = _registerRemoteAsset(
                  assets,
                  kind: DraftAssetKind.thumbnail,
                  url: frameDto.thumbnailUrl!,
                );
              }
              return DraftFrame(
                localId: 'frame-${_uuid.v4()}',
                remoteId: frameDto.id,
                localModifiedAt: now,
                remoteUpdateAt: frameDto.updateAt,
                data: DraftFrameData(
                  title: frameDto.title ?? '',
                  dialogue: frameDto.dialogue,
                  actionNote: frameDto.actionNote,
                  durationSec: frameDto.durationSec ?? 3,
                  sort: frameDto.sort,
                  imageAssetRef: imageRef,
                  thumbnailAssetRef: thumbRef,
                  acgnImageId: frameDto.acgnImageId,
                  acgnImageFileId: frameDto.acgnImageFileId,
                  cinePresetId: frameDto.cinePresetId,
                  shotType: frameDto.shotType ?? 'medium',
                  cameraMovement: frameDto.cameraMovement ?? '',
                  lensMm: frameDto.lensMm ?? 35.0,
                  aspectRatio: frameDto.aspectRatio ?? '16:9',
                  extraParams: frameDto.extraParams ?? {},
                ),
              );
            }).toList(),
          );
        }).toList(),
      );
    }).toList();

    return ScreenplayDraftManifest(
      draftId: id,
      source: DraftSource(
        type: DraftSourceType.remoteTemplate,
        remoteScreenplayId: tree.screenplay.id,
      ),
      sync: DraftSyncMeta(
        state: SyncState.synced,
        lastLocalSaveAt: now,
        lastRemoteSyncAt: now,
        pendingUpload: false,
      ),
      assets: assets,
      screenplay: DraftScreenplay(
        localId: 'sp-${_uuid.v4()}',
        remoteId: tree.screenplay.id,
        localModifiedAt: now,
        remoteUpdateAt: tree.screenplay.updateAt,
        data: DraftScreenplayData(
          kind: tree.screenplay.kind ?? 2,
          title: tree.screenplay.title,
          subtitle: tree.screenplay.subtitle ?? '',
          summary: tree.screenplay.summary ?? '',
          coverAssetRef: coverRef,
          publishStatus: tree.screenplay.publishStatus ?? 0,
          visibility: tree.screenplay.visibility ?? 0,
          templateAccess: tree.screenplay.templateAccess ?? 0,
          priceCents: tree.screenplay.priceCents ?? 0,
        ),
      ),
      acts: acts,
      authorName: tree.screenplay.authorName,
      authorAvatarUrl: tree.screenplay.authorAvatarUrl,
      authorLevel: tree.screenplay.authorLevel,
      likes: tree.screenplay.likes ?? 0,
      comments: tree.screenplay.comments ?? 0,
      views: tree.screenplay.views ?? 0,
      tags: tree.screenplay.tags ?? const [],
    );
  }

  String _registerRemoteAsset(
    Map<String, DraftAsset> assets, {
    required DraftAssetKind kind,
    required String url,
    int? imageId,
    int? imageFileId,
  }) {
    final ref = 'asset-${_uuid.v4().substring(0, 8)}';
    assets[ref] = DraftAsset(
      ref: ref,
      kind: kind,
      remoteUrl: url,
      remoteImageId: imageId,
      remoteImageFileId: imageFileId,
      syncState: AssetSyncState.synced,
      syncedAt: DateTime.now().toUtc(),
    );
    return ref;
  }
}
