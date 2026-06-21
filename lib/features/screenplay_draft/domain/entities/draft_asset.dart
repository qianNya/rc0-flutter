import 'package:rc0_flutter/features/screenplay_draft/domain/enums/sync_state.dart';

enum DraftAssetKind {
  cover('cover'),
  frameImage('frame_image'),
  thumbnail('thumbnail');

  const DraftAssetKind(this.value);

  final String value;

  static DraftAssetKind fromValue(String? value) {
    return DraftAssetKind.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DraftAssetKind.frameImage,
    );
  }
}

class DraftAsset {
  const DraftAsset({
    required this.ref,
    required this.kind,
    this.localUri,
    this.remoteUrl,
    this.remoteObjectKey,
    this.remoteImageId,
    this.remoteImageFileId,
    this.checksum,
    this.syncState = AssetSyncState.localOnly,
    this.syncedAt,
  });

  final String ref;
  final DraftAssetKind kind;
  final String? localUri;
  final String? remoteUrl;
  final String? remoteObjectKey;
  final int? remoteImageId;
  final int? remoteImageFileId;
  final String? checksum;
  final AssetSyncState syncState;
  final DateTime? syncedAt;

  DraftAsset copyWith({
    String? ref,
    DraftAssetKind? kind,
    String? localUri,
    String? remoteUrl,
    String? remoteObjectKey,
    int? remoteImageId,
    int? remoteImageFileId,
    String? checksum,
    AssetSyncState? syncState,
    DateTime? syncedAt,
  }) {
    return DraftAsset(
      ref: ref ?? this.ref,
      kind: kind ?? this.kind,
      localUri: localUri ?? this.localUri,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      remoteObjectKey: remoteObjectKey ?? this.remoteObjectKey,
      remoteImageId: remoteImageId ?? this.remoteImageId,
      remoteImageFileId: remoteImageFileId ?? this.remoteImageFileId,
      checksum: checksum ?? this.checksum,
      syncState: syncState ?? this.syncState,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'kind': kind.value,
    'local_uri': localUri,
    'remote_url': remoteUrl,
    'remote_object_key': remoteObjectKey,
    'remote_image_id': remoteImageId,
    'remote_image_file_id': remoteImageFileId,
    'checksum': checksum,
    'sync_state': syncState.value,
    'synced_at': syncedAt?.toUtc().toIso8601String(),
  };

  factory DraftAsset.fromJson(String ref, Map<String, dynamic> json) {
    return DraftAsset(
      ref: ref,
      kind: DraftAssetKind.fromValue(json['kind'] as String?),
      localUri: json['local_uri'] as String?,
      remoteUrl: json['remote_url'] as String?,
      remoteObjectKey: json['remote_object_key'] as String?,
      remoteImageId: json['remote_image_id'] as int?,
      remoteImageFileId: json['remote_image_file_id'] as int?,
      checksum: json['checksum'] as String?,
      syncState: AssetSyncState.fromValue(json['sync_state'] as String?),
      syncedAt: json['synced_at'] != null
          ? DateTime.tryParse(json['synced_at'] as String)
          : null,
    );
  }
}
