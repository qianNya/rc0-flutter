class DraftFrameData {
  const DraftFrameData({
    this.title = '',
    this.dialogue,
    this.actionNote,
    this.durationSec = 3,
    this.sort = 1,
    this.imageAssetRef,
    this.thumbnailAssetRef,
    this.acgnImageId,
    this.acgnImageFileId,
    this.cinePresetId,
    this.shotType = 'medium',
    this.cameraMovement = '',
    this.lensMm = 35.0,
    this.aspectRatio = '16:9',
    this.extraParams = const {},
  });

  final String title;
  final String? dialogue;
  final String? actionNote;
  final int durationSec;
  final int sort;
  final String? imageAssetRef;
  final String? thumbnailAssetRef;
  final int? acgnImageId;
  final int? acgnImageFileId;
  final int? cinePresetId;
  final String shotType;
  final String cameraMovement;
  final double lensMm;
  final String aspectRatio;
  final Map<String, dynamic> extraParams;

  DraftFrameData copyWith({
    String? title,
    String? dialogue,
    String? actionNote,
    int? durationSec,
    int? sort,
    String? imageAssetRef,
    String? thumbnailAssetRef,
    int? acgnImageId,
    int? acgnImageFileId,
    int? cinePresetId,
    String? shotType,
    String? cameraMovement,
    double? lensMm,
    String? aspectRatio,
    Map<String, dynamic>? extraParams,
  }) {
    return DraftFrameData(
      title: title ?? this.title,
      dialogue: dialogue ?? this.dialogue,
      actionNote: actionNote ?? this.actionNote,
      durationSec: durationSec ?? this.durationSec,
      sort: sort ?? this.sort,
      imageAssetRef: imageAssetRef ?? this.imageAssetRef,
      thumbnailAssetRef: thumbnailAssetRef ?? this.thumbnailAssetRef,
      acgnImageId: acgnImageId ?? this.acgnImageId,
      acgnImageFileId: acgnImageFileId ?? this.acgnImageFileId,
      cinePresetId: cinePresetId ?? this.cinePresetId,
      shotType: shotType ?? this.shotType,
      cameraMovement: cameraMovement ?? this.cameraMovement,
      lensMm: lensMm ?? this.lensMm,
      aspectRatio: aspectRatio ?? this.aspectRatio,
      extraParams: extraParams ?? this.extraParams,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'dialogue': dialogue,
    'action_note': actionNote,
    'duration_sec': durationSec,
    'sort': sort,
    'image_asset_ref': imageAssetRef,
    'thumbnail_asset_ref': thumbnailAssetRef,
    'acgn_image_id': acgnImageId,
    'acgn_image_file_id': acgnImageFileId,
    'cine_preset_id': cinePresetId,
    'shot_type': shotType,
    'camera_movement': cameraMovement,
    'lens_mm': lensMm,
    'aspect_ratio': aspectRatio,
    'extra_params': extraParams,
  };

  factory DraftFrameData.fromJson(Map<String, dynamic> json) {
    return DraftFrameData(
      title: json['title'] as String? ?? '',
      dialogue: json['dialogue'] as String?,
      actionNote: json['action_note'] as String?,
      durationSec: json['duration_sec'] as int? ?? 3,
      sort: json['sort'] as int? ?? 1,
      imageAssetRef: json['image_asset_ref'] as String?,
      thumbnailAssetRef: json['thumbnail_asset_ref'] as String?,
      acgnImageId: json['acgn_image_id'] as int?,
      acgnImageFileId: json['acgn_image_file_id'] as int?,
      cinePresetId: json['cine_preset_id'] as int?,
      shotType: json['shot_type'] as String? ?? 'medium',
      cameraMovement: json['camera_movement'] as String? ?? '',
      lensMm: (json['lens_mm'] as num?)?.toDouble() ?? 35.0,
      aspectRatio: json['aspect_ratio'] as String? ?? '16:9',
      extraParams: Map<String, dynamic>.from(
        json['extra_params'] as Map? ?? {},
      ),
    );
  }
}

class DraftFrame {
  const DraftFrame({
    required this.localId,
    this.remoteId,
    required this.localModifiedAt,
    this.remoteUpdateAt,
    required this.data,
  });

  final String localId;
  final int? remoteId;
  final DateTime localModifiedAt;
  final DateTime? remoteUpdateAt;
  final DraftFrameData data;

  DraftFrame copyWith({
    String? localId,
    int? remoteId,
    DateTime? localModifiedAt,
    DateTime? remoteUpdateAt,
    DraftFrameData? data,
  }) {
    return DraftFrame(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      localModifiedAt: localModifiedAt ?? this.localModifiedAt,
      remoteUpdateAt: remoteUpdateAt ?? this.remoteUpdateAt,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toJson() => {
    'local_id': localId,
    'remote_id': remoteId,
    'local_modified_at': localModifiedAt.toUtc().toIso8601String(),
    'remote_update_at': remoteUpdateAt?.toUtc().toIso8601String(),
    'data': data.toJson(),
  };

  factory DraftFrame.fromJson(Map<String, dynamic> json) {
    return DraftFrame(
      localId: json['local_id'] as String,
      remoteId: json['remote_id'] as int?,
      localModifiedAt: DateTime.parse(json['local_modified_at'] as String),
      remoteUpdateAt: json['remote_update_at'] != null
          ? DateTime.tryParse(json['remote_update_at'] as String)
          : null,
      data: DraftFrameData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class DraftSceneData {
  const DraftSceneData({
    this.title = '',
    this.summary,
    this.location = '',
    this.timeOfDay = '',
    this.sort = 1,
  });

  final String title;
  final String? summary;
  final String location;
  final String timeOfDay;
  final int sort;

  DraftSceneData copyWith({
    String? title,
    String? summary,
    String? location,
    String? timeOfDay,
    int? sort,
  }) {
    return DraftSceneData(
      title: title ?? this.title,
      summary: summary ?? this.summary,
      location: location ?? this.location,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      sort: sort ?? this.sort,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'summary': summary,
    'location': location,
    'time_of_day': timeOfDay,
    'sort': sort,
  };

  factory DraftSceneData.fromJson(Map<String, dynamic> json) {
    return DraftSceneData(
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String?,
      location: json['location'] as String? ?? '',
      timeOfDay: json['time_of_day'] as String? ?? '',
      sort: json['sort'] as int? ?? 1,
    );
  }
}

class DraftScene {
  const DraftScene({
    required this.localId,
    this.remoteId,
    required this.localModifiedAt,
    this.remoteUpdateAt,
    required this.data,
    this.frames = const [],
  });

  final String localId;
  final int? remoteId;
  final DateTime localModifiedAt;
  final DateTime? remoteUpdateAt;
  final DraftSceneData data;
  final List<DraftFrame> frames;

  DraftScene copyWith({
    String? localId,
    int? remoteId,
    DateTime? localModifiedAt,
    DateTime? remoteUpdateAt,
    DraftSceneData? data,
    List<DraftFrame>? frames,
  }) {
    return DraftScene(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      localModifiedAt: localModifiedAt ?? this.localModifiedAt,
      remoteUpdateAt: remoteUpdateAt ?? this.remoteUpdateAt,
      data: data ?? this.data,
      frames: frames ?? this.frames,
    );
  }

  Map<String, dynamic> toJson() => {
    'local_id': localId,
    'remote_id': remoteId,
    'local_modified_at': localModifiedAt.toUtc().toIso8601String(),
    'remote_update_at': remoteUpdateAt?.toUtc().toIso8601String(),
    'data': data.toJson(),
    'frames': frames.map((f) => f.toJson()).toList(),
  };

  factory DraftScene.fromJson(Map<String, dynamic> json) {
    return DraftScene(
      localId: json['local_id'] as String,
      remoteId: json['remote_id'] as int?,
      localModifiedAt: DateTime.parse(json['local_modified_at'] as String),
      remoteUpdateAt: json['remote_update_at'] != null
          ? DateTime.tryParse(json['remote_update_at'] as String)
          : null,
      data: DraftSceneData.fromJson(json['data'] as Map<String, dynamic>),
      frames: (json['frames'] as List<dynamic>? ?? [])
          .map((e) => DraftFrame.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DraftActData {
  const DraftActData({
    this.title = '',
    this.summary,
    this.sort = 1,
  });

  final String title;
  final String? summary;
  final int sort;

  DraftActData copyWith({String? title, String? summary, int? sort}) {
    return DraftActData(
      title: title ?? this.title,
      summary: summary ?? this.summary,
      sort: sort ?? this.sort,
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'summary': summary,
    'sort': sort,
  };

  factory DraftActData.fromJson(Map<String, dynamic> json) {
    return DraftActData(
      title: json['title'] as String? ?? '',
      summary: json['summary'] as String?,
      sort: json['sort'] as int? ?? 1,
    );
  }
}

class DraftAct {
  const DraftAct({
    required this.localId,
    this.remoteId,
    required this.localModifiedAt,
    this.remoteUpdateAt,
    required this.data,
    this.scenes = const [],
  });

  final String localId;
  final int? remoteId;
  final DateTime localModifiedAt;
  final DateTime? remoteUpdateAt;
  final DraftActData data;
  final List<DraftScene> scenes;

  DraftAct copyWith({
    String? localId,
    int? remoteId,
    DateTime? localModifiedAt,
    DateTime? remoteUpdateAt,
    DraftActData? data,
    List<DraftScene>? scenes,
  }) {
    return DraftAct(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      localModifiedAt: localModifiedAt ?? this.localModifiedAt,
      remoteUpdateAt: remoteUpdateAt ?? this.remoteUpdateAt,
      data: data ?? this.data,
      scenes: scenes ?? this.scenes,
    );
  }

  Map<String, dynamic> toJson() => {
    'local_id': localId,
    'remote_id': remoteId,
    'local_modified_at': localModifiedAt.toUtc().toIso8601String(),
    'remote_update_at': remoteUpdateAt?.toUtc().toIso8601String(),
    'data': data.toJson(),
    'scenes': scenes.map((s) => s.toJson()).toList(),
  };

  factory DraftAct.fromJson(Map<String, dynamic> json) {
    return DraftAct(
      localId: json['local_id'] as String,
      remoteId: json['remote_id'] as int?,
      localModifiedAt: DateTime.parse(json['local_modified_at'] as String),
      remoteUpdateAt: json['remote_update_at'] != null
          ? DateTime.tryParse(json['remote_update_at'] as String)
          : null,
      data: DraftActData.fromJson(json['data'] as Map<String, dynamic>),
      scenes: (json['scenes'] as List<dynamic>? ?? [])
          .map((e) => DraftScene.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DraftScreenplayData {
  const DraftScreenplayData({
    this.kind = 2,
    this.title = '',
    this.subtitle = '',
    this.summary = '',
    this.coverAssetRef,
    this.publishStatus = 0,
    this.visibility = 0,
    this.templateAccess = 0,
    this.priceCents = 0,
  });

  final int kind;
  final String title;
  final String subtitle;
  final String summary;
  final String? coverAssetRef;
  final int publishStatus;
  final int visibility;
  final int templateAccess;
  final int priceCents;

  DraftScreenplayData copyWith({
    int? kind,
    String? title,
    String? subtitle,
    String? summary,
    String? coverAssetRef,
    int? publishStatus,
    int? visibility,
    int? templateAccess,
    int? priceCents,
  }) {
    return DraftScreenplayData(
      kind: kind ?? this.kind,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      summary: summary ?? this.summary,
      coverAssetRef: coverAssetRef ?? this.coverAssetRef,
      publishStatus: publishStatus ?? this.publishStatus,
      visibility: visibility ?? this.visibility,
      templateAccess: templateAccess ?? this.templateAccess,
      priceCents: priceCents ?? this.priceCents,
    );
  }

  Map<String, dynamic> toJson() => {
    'kind': kind,
    'title': title,
    'subtitle': subtitle,
    'summary': summary,
    'cover_asset_ref': coverAssetRef,
    'publish_status': publishStatus,
    'visibility': visibility,
    'template_access': templateAccess,
    'price_cents': priceCents,
  };

  factory DraftScreenplayData.fromJson(Map<String, dynamic> json) {
    return DraftScreenplayData(
      kind: json['kind'] as int? ?? 2,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      summary: json['summary'] as String? ?? '',
      coverAssetRef: json['cover_asset_ref'] as String?,
      publishStatus: json['publish_status'] as int? ?? 0,
      visibility: json['visibility'] as int? ?? 0,
      templateAccess: json['template_access'] as int? ?? 0,
      priceCents: json['price_cents'] as int? ?? 0,
    );
  }
}

class DraftScreenplay {
  const DraftScreenplay({
    required this.localId,
    this.remoteId,
    required this.localModifiedAt,
    this.remoteUpdateAt,
    required this.data,
  });

  final String localId;
  final int? remoteId;
  final DateTime localModifiedAt;
  final DateTime? remoteUpdateAt;
  final DraftScreenplayData data;

  DraftScreenplay copyWith({
    String? localId,
    int? remoteId,
    DateTime? localModifiedAt,
    DateTime? remoteUpdateAt,
    DraftScreenplayData? data,
  }) {
    return DraftScreenplay(
      localId: localId ?? this.localId,
      remoteId: remoteId ?? this.remoteId,
      localModifiedAt: localModifiedAt ?? this.localModifiedAt,
      remoteUpdateAt: remoteUpdateAt ?? this.remoteUpdateAt,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toJson() => {
    'local_id': localId,
    'remote_id': remoteId,
    'local_modified_at': localModifiedAt.toUtc().toIso8601String(),
    'remote_update_at': remoteUpdateAt?.toUtc().toIso8601String(),
    'data': data.toJson(),
  };

  factory DraftScreenplay.fromJson(Map<String, dynamic> json) {
    return DraftScreenplay(
      localId: json['local_id'] as String,
      remoteId: json['remote_id'] as int?,
      localModifiedAt: DateTime.parse(json['local_modified_at'] as String),
      remoteUpdateAt: json['remote_update_at'] != null
          ? DateTime.tryParse(json['remote_update_at'] as String)
          : null,
      data: DraftScreenplayData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}
