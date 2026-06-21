import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/features/frame_viewer/presentation/frame_viewer_view.dart';

class FrameViewerPage extends ConsumerWidget {
  const FrameViewerPage({
    super.key,
    required this.screenplayId,
    required this.sceneId,
    required this.initialIndex,
  });

  final String screenplayId;
  final String sceneId;
  final int initialIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FrameViewerView(
      screenplayId: screenplayId,
      sceneId: sceneId,
      initialIndex: initialIndex,
    );
  }
}
