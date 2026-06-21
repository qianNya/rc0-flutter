import 'package:rc0_flutter/core/error/app_exception.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/frame_viewer/data/datasources/frame_datasource.dart';
import 'package:rc0_flutter/features/frame_viewer/domain/entities/frame_item.dart';
import 'package:rc0_flutter/features/frame_viewer/domain/repositories/frame_viewer_repository.dart';
import 'package:rc0_flutter/features/screenplay/data/datasources/screenplay_datasource.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/mappers/from_server_tree_mapper.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/mappers/to_display_tree_mapper.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/display_tree.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/services/draft_storage_service.dart';

class FrameViewerRepositoryImpl implements FrameViewerRepository {
  FrameViewerRepositoryImpl({
    required DraftStorageService storage,
    required ScreenplayDatasource screenplayDatasource,
    required FrameDatasource frameDatasource,
    ToDisplayTreeMapper? displayMapper,
    FromServerTreeMapper? fromServerMapper,
  }) : _storage = storage,
       _screenplayDatasource = screenplayDatasource,
       _frameDatasource = frameDatasource,
       _displayMapper = displayMapper ?? const ToDisplayTreeMapper(),
       _fromServerMapper = fromServerMapper ?? FromServerTreeMapper();

  final DraftStorageService _storage;
  final ScreenplayDatasource _screenplayDatasource;
  final FrameDatasource _frameDatasource;
  final ToDisplayTreeMapper _displayMapper;
  final FromServerTreeMapper _fromServerMapper;

  @override
  Future<Result<List<FrameItem>>> getSceneFrames({
    required String screenplayId,
    required String sceneId,
  }) async {
    try {
      if (sceneId != 'legacy') {
        final sceneRemoteId = int.tryParse(sceneId);
        if (sceneRemoteId != null && !await _storage.exists(screenplayId)) {
          final frames = await _frameDatasource.getSceneFrames(sceneRemoteId);
          return Success(
            frames
                .asMap()
                .entries
                .map(
                  (e) => FrameItem(
                    id: '${e.value.id}',
                    localId: '${e.value.id}',
                    imageUrl: e.value.imageUrl,
                    thumbnailUrl: e.value.thumbnailUrl,
                    title: e.value.title ?? '',
                    durationSec: e.value.durationSec ?? 3,
                    index: e.key,
                  ),
                )
                .toList(),
          );
        }
      }

      final draftRoot = await _storage.draftRootFor(screenplayId);
      if (await _storage.exists(screenplayId)) {
        final manifest = await _storage.load(screenplayId);
        final tree = _displayMapper(manifest, draftRoot: draftRoot);
        return Success(_framesFromTree(tree, sceneId));
      }

      final remoteId = int.tryParse(screenplayId);
      if (remoteId == null) {
        return const Failure(UnknownException('无效的剧本 ID'));
      }

      final apiTree = await _screenplayDatasource.getTree(remoteId);
      final manifest = _fromServerMapper(apiTree, draftId: screenplayId);
      final tree = _displayMapper(manifest, draftRoot: draftRoot);
      return Success(_framesFromTree(tree, sceneId));
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  List<FrameItem> _framesFromTree(DisplayTree tree, String sceneId) {
    if (sceneId == 'legacy') {
      final allFrames = <FrameItem>[];
      var globalIndex = 0;
      for (final act in tree.acts) {
        for (final scene in act.scenes) {
          for (final f in scene.frames) {
            allFrames.add(
              FrameItem(
                id: f.id,
                localId: f.localId,
                imageUrl: f.imageUrl,
                thumbnailUrl: f.thumbnailUrl,
                title: f.title,
                durationSec: f.durationSec,
                index: globalIndex++,
              ),
            );
          }
        }
      }
      return allFrames;
    }

    final scene = tree.findSceneById(sceneId);
    if (scene == null) return [];
    return scene.frames
        .map(
          (f) => FrameItem(
            id: f.id,
            localId: f.localId,
            imageUrl: f.imageUrl,
            thumbnailUrl: f.thumbnailUrl,
            title: f.title,
            durationSec: f.durationSec,
            index: f.index,
          ),
        )
        .toList();
  }
}
