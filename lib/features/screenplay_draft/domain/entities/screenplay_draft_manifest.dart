import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_asset.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_nodes.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/enums/draft_source_type.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/enums/sync_state.dart';

class DraftSource {
  const DraftSource({
    required this.type,
    this.remoteScreenplayId,
    this.forkSourceId,
  });

  final DraftSourceType type;
  final int? remoteScreenplayId;
  final int? forkSourceId;

  Map<String, dynamic> toJson() => {
    'type': type.value,
    'remote_screenplay_id': remoteScreenplayId,
    'fork_source_id': forkSourceId,
  };

  factory DraftSource.fromJson(Map<String, dynamic> json) {
    return DraftSource(
      type: DraftSourceType.fromValue(json['type'] as String?),
      remoteScreenplayId: json['remote_screenplay_id'] as int?,
      forkSourceId: json['fork_source_id'] as int?,
    );
  }
}

class DraftSyncMeta {
  const DraftSyncMeta({
    this.state = SyncState.localOnly,
    this.lastLocalSaveAt,
    this.lastRemoteSyncAt,
    this.pendingUpload = true,
  });

  final SyncState state;
  final DateTime? lastLocalSaveAt;
  final DateTime? lastRemoteSyncAt;
  final bool pendingUpload;

  DraftSyncMeta copyWith({
    SyncState? state,
    DateTime? lastLocalSaveAt,
    DateTime? lastRemoteSyncAt,
    bool? pendingUpload,
  }) {
    return DraftSyncMeta(
      state: state ?? this.state,
      lastLocalSaveAt: lastLocalSaveAt ?? this.lastLocalSaveAt,
      lastRemoteSyncAt: lastRemoteSyncAt ?? this.lastRemoteSyncAt,
      pendingUpload: pendingUpload ?? this.pendingUpload,
    );
  }

  Map<String, dynamic> toJson() => {
    'state': state.value,
    'last_local_save_at': lastLocalSaveAt?.toUtc().toIso8601String(),
    'last_remote_sync_at': lastRemoteSyncAt?.toUtc().toIso8601String(),
    'pending_upload': pendingUpload,
  };

  factory DraftSyncMeta.fromJson(Map<String, dynamic> json) {
    return DraftSyncMeta(
      state: SyncState.fromValue(json['state'] as String?),
      lastLocalSaveAt: json['last_local_save_at'] != null
          ? DateTime.tryParse(json['last_local_save_at'] as String)
          : null,
      lastRemoteSyncAt: json['last_remote_sync_at'] != null
          ? DateTime.tryParse(json['last_remote_sync_at'] as String)
          : null,
      pendingUpload: json['pending_upload'] as bool? ?? true,
    );
  }
}

class ScreenplayDraftManifest {
  const ScreenplayDraftManifest({
    this.schemaVersion = 1,
    required this.draftId,
    required this.source,
    required this.sync,
    this.assets = const {},
    required this.screenplay,
    this.acts = const [],
    this.authorName,
    this.authorAvatarUrl,
    this.authorLevel,
    this.likes = 0,
    this.comments = 0,
    this.views = 0,
    this.tags = const [],
  });

  final int schemaVersion;
  final String draftId;
  final DraftSource source;
  final DraftSyncMeta sync;
  final Map<String, DraftAsset> assets;
  final DraftScreenplay screenplay;
  final List<DraftAct> acts;
  final String? authorName;
  final String? authorAvatarUrl;
  final int? authorLevel;
  final int likes;
  final int comments;
  final int views;
  final List<String> tags;

  ScreenplayDraftManifest copyWith({
    int? schemaVersion,
    String? draftId,
    DraftSource? source,
    DraftSyncMeta? sync,
    Map<String, DraftAsset>? assets,
    DraftScreenplay? screenplay,
    List<DraftAct>? acts,
    String? authorName,
    String? authorAvatarUrl,
    int? authorLevel,
    int? likes,
    int? comments,
    int? views,
    List<String>? tags,
  }) {
    return ScreenplayDraftManifest(
      schemaVersion: schemaVersion ?? this.schemaVersion,
      draftId: draftId ?? this.draftId,
      source: source ?? this.source,
      sync: sync ?? this.sync,
      assets: assets ?? this.assets,
      screenplay: screenplay ?? this.screenplay,
      acts: acts ?? this.acts,
      authorName: authorName ?? this.authorName,
      authorAvatarUrl: authorAvatarUrl ?? this.authorAvatarUrl,
      authorLevel: authorLevel ?? this.authorLevel,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      views: views ?? this.views,
      tags: tags ?? this.tags,
    );
  }

  Map<String, dynamic> toJson() => {
    'schema_version': schemaVersion,
    'draft_id': draftId,
    'source': source.toJson(),
    'sync': sync.toJson(),
    'assets': assets.map((key, value) => MapEntry(key, value.toJson())),
    'screenplay': screenplay.toJson(),
    'acts': acts.map((a) => a.toJson()).toList(),
    if (authorName != null) 'author_name': authorName,
    if (authorAvatarUrl != null) 'author_avatar_url': authorAvatarUrl,
    if (authorLevel != null) 'author_level': authorLevel,
    if (likes > 0) 'likes': likes,
    if (comments > 0) 'comments': comments,
    if (views > 0) 'views': views,
    if (tags.isNotEmpty) 'tags': tags,
  };

  factory ScreenplayDraftManifest.fromJson(Map<String, dynamic> json) {
    final rawAssets = json['assets'] as Map<String, dynamic>? ?? {};
    return ScreenplayDraftManifest(
      schemaVersion: json['schema_version'] as int? ?? 1,
      draftId: json['draft_id'] as String,
      source: DraftSource.fromJson(json['source'] as Map<String, dynamic>),
      sync: DraftSyncMeta.fromJson(json['sync'] as Map<String, dynamic>),
      assets: rawAssets.map(
        (key, value) => MapEntry(
          key,
          DraftAsset.fromJson(key, value as Map<String, dynamic>),
        ),
      ),
      screenplay: DraftScreenplay.fromJson(
        json['screenplay'] as Map<String, dynamic>,
      ),
      acts: (json['acts'] as List<dynamic>? ?? [])
          .map((e) => DraftAct.fromJson(e as Map<String, dynamic>))
          .toList(),
      authorName: json['author_name'] as String?,
      authorAvatarUrl: json['author_avatar_url'] as String?,
      authorLevel: json['author_level'] as int?,
      likes: json['likes'] as int? ?? 0,
      comments: json['comments'] as int? ?? 0,
      views: json['views'] as int? ?? 0,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          const [],
    );
  }
}
