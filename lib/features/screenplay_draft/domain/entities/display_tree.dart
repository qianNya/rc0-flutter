class DisplayFrameThumb {
  const DisplayFrameThumb({
    required this.id,
    required this.localId,
    this.title = '',
    this.imageUrl,
    this.thumbnailUrl,
    this.durationSec = 3,
    this.aspectRatio = '16:9',
    this.cinePresetId,
    this.shotType = 'medium',
    this.index = 0,
  });

  final String id;
  final String localId;
  final String title;
  final String? imageUrl;
  final String? thumbnailUrl;
  final int durationSec;
  final String aspectRatio;
  final int? cinePresetId;
  final String shotType;
  final int index;
}

class DisplayScene {
  const DisplayScene({
    required this.id,
    required this.localId,
    required this.title,
    this.summary,
    this.frameCount = 0,
    this.totalDurationSec = 0,
    this.frames = const [],
    this.sort = 1,
  });

  final String id;
  final String localId;
  final String title;
  final String? summary;
  final int frameCount;
  final int totalDurationSec;
  final List<DisplayFrameThumb> frames;
  final int sort;
}

class DisplayAct {
  const DisplayAct({
    required this.id,
    required this.localId,
    required this.title,
    this.scenes = const [],
    this.sort = 1,
  });

  final String id;
  final String localId;
  final String title;
  final List<DisplayScene> scenes;
  final int sort;
}

class DisplayTree {
  const DisplayTree({
    required this.id,
    required this.draftId,
    required this.title,
    this.subtitle = '',
    this.summary = '',
    this.coverUrl,
    this.authorName = '未知作者',
    this.authorAvatarUrl = '',
    this.authorLevel = 1,
    this.likes = 0,
    this.comments = 0,
    this.views = 0,
    this.tags = const [],
    this.acts = const [],
    this.isLocalDraft = false,
    this.syncState,
  });

  final String id;
  final String draftId;
  final String title;
  final String subtitle;
  final String summary;
  final String? coverUrl;
  final String authorName;
  final String authorAvatarUrl;
  final int authorLevel;
  final int likes;
  final int comments;
  final int views;
  final List<String> tags;
  final List<DisplayAct> acts;
  final bool isLocalDraft;
  final String? syncState;

  DisplayScene? findSceneById(String sceneId) {
    for (final act in acts) {
      for (final scene in act.scenes) {
        if (scene.id == sceneId || scene.localId == sceneId) {
          return scene;
        }
      }
    }
    return null;
  }

  List<DisplayFrameThumb> framesForScene(String sceneId) {
    return findSceneById(sceneId)?.frames ?? const [];
  }
}
