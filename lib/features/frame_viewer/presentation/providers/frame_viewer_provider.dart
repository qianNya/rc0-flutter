import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/frame_viewer/data/datasources/frame_datasource.dart';
import 'package:rc0_flutter/features/frame_viewer/data/datasources/remote_frame_datasource.dart';
import 'package:rc0_flutter/features/frame_viewer/data/repositories/frame_viewer_repository_impl.dart';
import 'package:rc0_flutter/features/frame_viewer/domain/entities/frame_item.dart';
import 'package:rc0_flutter/features/frame_viewer/domain/repositories/frame_viewer_repository.dart';
import 'package:rc0_flutter/features/frame_viewer/domain/usecases/get_scene_frames_usecase.dart';
import 'package:rc0_flutter/features/screenplay/presentation/providers/screenplay_providers.dart';

final frameDatasourceProvider = Provider<FrameDatasource>((ref) {
  return RemoteFrameDatasource(ref.watch(dioClientProvider));
});

final frameViewerRepositoryProvider = Provider<FrameViewerRepository>((ref) {
  return FrameViewerRepositoryImpl(
    storage: ref.watch(draftStorageServiceProvider),
    screenplayDatasource: ref.watch(screenplayDatasourceProvider),
    frameDatasource: ref.watch(frameDatasourceProvider),
  );
});

final getSceneFramesUseCaseProvider = Provider<GetSceneFramesUseCase>((ref) {
  return GetSceneFramesUseCase(ref.watch(frameViewerRepositoryProvider));
});

class FrameViewerParams {
  const FrameViewerParams({
    required this.screenplayId,
    required this.sceneId,
    required this.initialIndex,
  });

  final String screenplayId;
  final String sceneId;
  final int initialIndex;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FrameViewerParams &&
          screenplayId == other.screenplayId &&
          sceneId == other.sceneId &&
          initialIndex == other.initialIndex;

  @override
  int get hashCode => Object.hash(screenplayId, sceneId, initialIndex);
}

class FrameViewerState {
  const FrameViewerState({
    this.frames = const [],
    this.currentIndex = 0,
    this.isLoading = false,
    this.error,
  });

  final List<FrameItem> frames;
  final int currentIndex;
  final bool isLoading;
  final String? error;

  FrameViewerState copyWith({
    List<FrameItem>? frames,
    int? currentIndex,
    bool? isLoading,
    String? error,
  }) {
    return FrameViewerState(
      frames: frames ?? this.frames,
      currentIndex: currentIndex ?? this.currentIndex,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FrameViewerNotifier extends StateNotifier<FrameViewerState> {
  FrameViewerNotifier(this._getFrames, this._params)
    : super(FrameViewerState(currentIndex: _params.initialIndex)) {
    load();
  }

  final GetSceneFramesUseCase _getFrames;
  final FrameViewerParams _params;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getFrames(
      screenplayId: _params.screenplayId,
      sceneId: _params.sceneId,
    );
    if (result is Failure<List<FrameItem>>) {
      state = state.copyWith(
        isLoading: false,
        error: result.exception.toString(),
      );
      return;
    }
    final frames = (result as Success<List<FrameItem>>).data;
    var index = _params.initialIndex;
    if (index >= frames.length) index = 0;
    state = state.copyWith(
      frames: frames,
      currentIndex: index,
      isLoading: false,
    );
  }

  void goTo(int index) {
    if (index < 0 || index >= state.frames.length) return;
    state = state.copyWith(currentIndex: index);
  }

  void next() => goTo(state.currentIndex + 1);
  void previous() => goTo(state.currentIndex - 1);
}

final frameViewerProvider = StateNotifierProvider.family<
    FrameViewerNotifier, FrameViewerState, FrameViewerParams>((ref, params) {
  return FrameViewerNotifier(
    ref.watch(getSceneFramesUseCaseProvider),
    params,
  );
});
