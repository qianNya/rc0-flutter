class ScreenplayNodeDto {
  const ScreenplayNodeDto({
    required this.id,
    required this.title,
    this.subtitle,
    this.summary,
    this.coverUrl,
    this.kind,
    this.publishStatus,
    this.visibility,
    this.templateAccess,
    this.priceCents,
    this.authorName,
    this.authorAvatarUrl,
    this.authorLevel,
    this.likes,
    this.comments,
    this.views,
    this.tags,
    this.updateAt,
  });

  final int id;
  final String title;
  final String? subtitle;
  final String? summary;
  final String? coverUrl;
  final int? kind;
  final int? publishStatus;
  final int? visibility;
  final int? templateAccess;
  final int? priceCents;
  final String? authorName;
  final String? authorAvatarUrl;
  final int? authorLevel;
  final int? likes;
  final int? comments;
  final int? views;
  final List<String>? tags;
  final DateTime? updateAt;

  factory ScreenplayNodeDto.fromJson(Map<String, dynamic> json) {
    return ScreenplayNodeDto(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      summary: json['summary'] as String?,
      coverUrl: json['cover_url'] as String?,
      kind: json['kind'] as int?,
      publishStatus: json['publish_status'] as int?,
      visibility: json['visibility'] as int?,
      templateAccess: json['template_access'] as int?,
      priceCents: json['price_cents'] as int?,
      authorName: json['author_name'] as String?,
      authorAvatarUrl: json['author_avatar_url'] as String?,
      authorLevel: json['author_level'] as int?,
      likes: json['like_count'] as int? ?? json['likes'] as int?,
      comments: json['comment_count'] as int? ?? json['comments'] as int?,
      views: json['view_count'] as int? ?? json['views'] as int?,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      updateAt: json['update_at'] != null
          ? DateTime.tryParse(json['update_at'] as String)
          : null,
    );
  }
}

class ActNodeDto {
  const ActNodeDto({
    required this.id,
    required this.title,
    this.summary,
    this.sort = 1,
    this.updateAt,
  });

  final int id;
  final String title;
  final String? summary;
  final int sort;
  final DateTime? updateAt;

  factory ActNodeDto.fromJson(Map<String, dynamic> json) {
    return ActNodeDto(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String?,
      sort: json['sort'] as int? ?? 1,
      updateAt: json['update_at'] != null
          ? DateTime.tryParse(json['update_at'] as String)
          : null,
    );
  }
}

class SceneNodeDto {
  const SceneNodeDto({
    required this.id,
    required this.title,
    this.summary,
    this.location,
    this.timeOfDay,
    this.sort = 1,
    this.updateAt,
  });

  final int id;
  final String title;
  final String? summary;
  final String? location;
  final String? timeOfDay;
  final int sort;
  final DateTime? updateAt;

  factory SceneNodeDto.fromJson(Map<String, dynamic> json) {
    return SceneNodeDto(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String?,
      location: json['location'] as String?,
      timeOfDay: json['time_of_day'] as String?,
      sort: json['sort'] as int? ?? 1,
      updateAt: json['update_at'] != null
          ? DateTime.tryParse(json['update_at'] as String)
          : null,
    );
  }
}

class FrameNodeDto {
  const FrameNodeDto({
    required this.id,
    this.title,
    this.dialogue,
    this.actionNote,
    this.durationSec,
    this.sort = 1,
    this.imageUrl,
    this.thumbnailUrl,
    this.acgnImageId,
    this.acgnImageFileId,
    this.cinePresetId,
    this.shotType,
    this.cameraMovement,
    this.lensMm,
    this.aspectRatio,
    this.extraParams,
    this.updateAt,
  });

  final int id;
  final String? title;
  final String? dialogue;
  final String? actionNote;
  final int? durationSec;
  final int sort;
  final String? imageUrl;
  final String? thumbnailUrl;
  final int? acgnImageId;
  final int? acgnImageFileId;
  final int? cinePresetId;
  final String? shotType;
  final String? cameraMovement;
  final double? lensMm;
  final String? aspectRatio;
  final Map<String, dynamic>? extraParams;
  final DateTime? updateAt;

  factory FrameNodeDto.fromJson(Map<String, dynamic> json) {
    return FrameNodeDto(
      id: json['id'] as int,
      title: json['title'] as String?,
      dialogue: json['dialogue'] as String?,
      actionNote: json['action_note'] as String?,
      durationSec: json['duration_sec'] as int?,
      sort: json['sort'] as int? ?? 1,
      imageUrl: json['image_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      acgnImageId: json['acgn_image_id'] as int?,
      acgnImageFileId: json['acgn_image_file_id'] as int?,
      cinePresetId: json['cine_preset_id'] as int?,
      shotType: json['shot_type'] as String?,
      cameraMovement: json['camera_movement'] as String?,
      lensMm: (json['lens_mm'] as num?)?.toDouble(),
      aspectRatio: json['aspect_ratio'] as String?,
      extraParams: json['extra_params'] != null
          ? Map<String, dynamic>.from(json['extra_params'] as Map)
          : null,
      updateAt: json['update_at'] != null
          ? DateTime.tryParse(json['update_at'] as String)
          : null,
    );
  }
}

class SceneTreeDto {
  const SceneTreeDto({
    required this.scene,
    this.frames = const [],
  });

  final SceneNodeDto scene;
  final List<FrameNodeDto> frames;

  factory SceneTreeDto.fromJson(Map<String, dynamic> json) {
    final sceneJson = json['scene'] as Map<String, dynamic>? ?? json;
    return SceneTreeDto(
      scene: SceneNodeDto.fromJson(sceneJson),
      frames: (json['frames'] as List<dynamic>? ?? [])
          .map((e) => FrameNodeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ActTreeDto {
  const ActTreeDto({
    required this.act,
    this.scenes = const [],
  });

  final ActNodeDto act;
  final List<SceneTreeDto> scenes;

  factory ActTreeDto.fromJson(Map<String, dynamic> json) {
    final actJson = json['act'] as Map<String, dynamic>? ?? json;
    return ActTreeDto(
      act: ActNodeDto.fromJson(actJson),
      scenes: (json['scenes'] as List<dynamic>? ?? [])
          .map((e) => SceneTreeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ScreenplayTreeDto {
  const ScreenplayTreeDto({
    required this.screenplay,
    this.acts = const [],
  });

  final ScreenplayNodeDto screenplay;
  final List<ActTreeDto> acts;

  factory ScreenplayTreeDto.fromJson(Map<String, dynamic> json) {
    final spJson = json['screenplay'] as Map<String, dynamic>? ?? json;
    return ScreenplayTreeDto(
      screenplay: ScreenplayNodeDto.fromJson(spJson),
      acts: (json['acts'] as List<dynamic>? ?? [])
          .map((e) => ActTreeDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ImageUploadResultDto {
  const ImageUploadResultDto({
    required this.id,
    this.fileId,
    this.url,
    this.objectKey,
  });

  final int id;
  final int? fileId;
  final String? url;
  final String? objectKey;

  factory ImageUploadResultDto.fromJson(Map<String, dynamic> json) {
    return ImageUploadResultDto(
      id: json['id'] as int,
      fileId: json['file_id'] as int?,
      url: json['url'] as String?,
      objectKey: json['object_key'] as String?,
    );
  }
}

class CreatedNodeDto {
  const CreatedNodeDto({
    required this.id,
    this.updateAt,
  });

  final int id;
  final DateTime? updateAt;

  factory CreatedNodeDto.fromJson(Map<String, dynamic> json) {
    return CreatedNodeDto(
      id: json['id'] as int,
      updateAt: json['update_at'] != null
          ? DateTime.tryParse(json['update_at'] as String)
          : null,
    );
  }
}
