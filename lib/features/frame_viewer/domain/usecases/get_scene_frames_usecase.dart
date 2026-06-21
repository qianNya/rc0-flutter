import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/frame_viewer/domain/entities/frame_item.dart';
import 'package:rc0_flutter/features/frame_viewer/domain/repositories/frame_viewer_repository.dart';

class GetSceneFramesUseCase {
  const GetSceneFramesUseCase(this._repository);

  final FrameViewerRepository _repository;

  Future<Result<List<FrameItem>>> call({
    required String screenplayId,
    required String sceneId,
  }) =>
      _repository.getSceneFrames(
        screenplayId: screenplayId,
        sceneId: sceneId,
      );
}
