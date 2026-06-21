import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_asset.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/enums/sync_state.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/screenplay_draft_manifest.dart';

class ToCreatePayloadMapper {
  const ToCreatePayloadMapper();

  Map<String, dynamic> screenplayPayload(ScreenplayDraftManifest manifest) {
    final data = manifest.screenplay.data;
    return {
      'kind': data.kind,
      'title': data.title,
      'subtitle': data.subtitle,
      'summary': data.summary,
      'visibility': data.visibility,
      'template_access': data.templateAccess,
      'price_cents': data.priceCents,
    };
  }

  Map<String, dynamic> actPayload(dynamic act) {
    return {
      'title': act.data.title,
      'summary': act.data.summary,
      'sort': act.data.sort,
    };
  }

  Map<String, dynamic> scenePayload(dynamic scene) {
    return {
      'title': scene.data.title,
      'summary': scene.data.summary,
      'location': scene.data.location,
      'time_of_day': scene.data.timeOfDay,
      'sort': scene.data.sort,
    };
  }

  Map<String, dynamic> framePayload(
    dynamic frame,
    ScreenplayDraftManifest manifest,
  ) {
    final data = frame.data;
    int? acgnImageId = data.acgnImageId;
    if (data.imageAssetRef != null) {
      final asset = manifest.assets[data.imageAssetRef];
      acgnImageId ??= asset?.remoteImageId;
    }
    return {
      'title': data.title,
      'dialogue': data.dialogue,
      'action_note': data.actionNote,
      'duration_sec': data.durationSec,
      'sort': data.sort,
      if (acgnImageId != null) 'acgn_image_id': acgnImageId,
      if (data.acgnImageFileId != null)
        'acgn_image_file_id': data.acgnImageFileId,
      if (data.cinePresetId != null) 'cine_preset_id': data.cinePresetId,
      'shot_type': data.shotType,
      'camera_movement': data.cameraMovement,
      'lens_mm': data.lensMm,
      'aspect_ratio': data.aspectRatio,
      if (data.extraParams.isNotEmpty) 'extra_params': data.extraParams,
    };
  }

  String? localAssetPath(
    ScreenplayDraftManifest manifest,
    String? assetRef,
    String draftRoot,
  ) {
    if (assetRef == null) return null;
    final asset = manifest.assets[assetRef];
    if (asset == null) return null;
    if (asset.syncState == AssetSyncState.synced &&
        asset.remoteImageId != null) {
      return null;
    }
    if (asset.localUri != null) {
      return '$draftRoot/${asset.localUri}';
    }
    return null;
  }
}
