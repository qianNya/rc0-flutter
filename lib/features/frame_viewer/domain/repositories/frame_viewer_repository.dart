import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/frame_viewer/domain/entities/frame_item.dart';

abstract class FrameViewerRepository {
  Future<Result<List<FrameItem>>> getSceneFrames({
    required String screenplayId,
    required String sceneId,
  });
}
