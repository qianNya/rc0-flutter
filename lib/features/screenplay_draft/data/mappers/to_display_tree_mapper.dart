import 'package:rc0_flutter/features/screenplay_draft/data/services/asset_resolver.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/display_tree.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_nodes.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/screenplay_draft_manifest.dart';

class ToDisplayTreeMapper {
  const ToDisplayTreeMapper({AssetResolver? resolver})
    : _resolver = resolver ?? const AssetResolver();

  final AssetResolver _resolver;

  DisplayTree call(ScreenplayDraftManifest manifest, {String? draftRoot}) {
    final sp = manifest.screenplay;
    final displayId = sp.remoteId?.toString() ?? manifest.draftId;

    return DisplayTree(
      id: displayId,
      draftId: manifest.draftId,
      title: sp.data.title,
      subtitle: sp.data.subtitle,
      summary: sp.data.summary,
      coverUrl: _resolver.resolveDisplayUri(
        manifest,
        sp.data.coverAssetRef,
        draftRoot: draftRoot,
      ),
      authorName: manifest.authorName ?? '未知作者',
      authorAvatarUrl: manifest.authorAvatarUrl ?? '',
      authorLevel: manifest.authorLevel ?? 1,
      likes: manifest.likes,
      comments: manifest.comments,
      views: manifest.views,
      tags: manifest.tags,
      acts: manifest.acts.map((act) => _mapAct(manifest, act, draftRoot)).toList(),
      isLocalDraft: sp.remoteId == null,
      syncState: manifest.sync.state.value,
    );
  }

  DisplayAct _mapAct(
    ScreenplayDraftManifest manifest,
    DraftAct act,
    String? draftRoot,
  ) {
    final actId = act.remoteId?.toString() ?? act.localId;
    return DisplayAct(
      id: actId,
      localId: act.localId,
      title: act.data.title,
      sort: act.data.sort,
      scenes: act.scenes
          .map((s) => _mapScene(manifest, s, draftRoot))
          .toList(),
    );
  }

  DisplayScene _mapScene(
    ScreenplayDraftManifest manifest,
    DraftScene scene,
    String? draftRoot,
  ) {
    final sceneId = scene.remoteId?.toString() ?? scene.localId;
    final frames = scene.frames;
    var totalDuration = 0;
    final displayFrames = <DisplayFrameThumb>[];
    for (var i = 0; i < frames.length; i++) {
      final frame = frames[i];
      final duration = frame.data.durationSec;
      totalDuration += duration;
      displayFrames.add(
        DisplayFrameThumb(
          id: frame.remoteId?.toString() ?? frame.localId,
          localId: frame.localId,
          title: frame.data.title,
          imageUrl: _resolver.resolveDisplayUri(
            manifest,
            frame.data.imageAssetRef,
            draftRoot: draftRoot,
          ),
          thumbnailUrl: _resolver.resolveDisplayUri(
            manifest,
            frame.data.thumbnailAssetRef,
            draftRoot: draftRoot,
          ) ??
              _resolver.resolveDisplayUri(
                manifest,
                frame.data.imageAssetRef,
                draftRoot: draftRoot,
              ),
          durationSec: duration,
          aspectRatio: frame.data.aspectRatio,
          cinePresetId: frame.data.cinePresetId,
          shotType: frame.data.shotType,
          index: i,
        ),
      );
    }

    return DisplayScene(
      id: sceneId,
      localId: scene.localId,
      title: scene.data.title,
      summary: scene.data.summary,
      frameCount: frames.length,
      totalDurationSec: totalDuration,
      frames: displayFrames,
      sort: scene.data.sort,
    );
  }
}
