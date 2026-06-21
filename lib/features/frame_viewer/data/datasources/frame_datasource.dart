import 'package:rc0_flutter/features/screenplay/data/models/screenplay_tree_dto.dart';

abstract class FrameDatasource {
  Future<List<FrameNodeDto>> getSceneFrames(int sceneRemoteId);
  Future<FrameNodeDto> getFrame(int frameId);
}
