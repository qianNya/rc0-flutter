import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/screenplay_detail/domain/usecases/screenplay_detail_usecases.dart';
import 'package:rc0_flutter/features/screenplay_detail/presentation/providers/screenplay_detail_repository_provider.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/display_tree.dart';

class ScreenplayDetailState {
  const ScreenplayDetailState({
    this.detail,
    this.selectedTab = 0,
    this.isLoading = false,
    this.isForking = false,
    this.error,
  });

  final DisplayTree? detail;
  final int selectedTab;
  final bool isLoading;
  final bool isForking;
  final String? error;

  ScreenplayDetailState copyWith({
    DisplayTree? detail,
    int? selectedTab,
    bool? isLoading,
    bool? isForking,
    String? error,
  }) {
    return ScreenplayDetailState(
      detail: detail ?? this.detail,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      isForking: isForking ?? this.isForking,
      error: error,
    );
  }
}

class ScreenplayDetailNotifier extends StateNotifier<ScreenplayDetailState> {
  ScreenplayDetailNotifier(
    this._getDetail,
    this._fork,
    this._favorite,
    this._id,
  ) : super(const ScreenplayDetailState()) {
    load();
  }

  final GetScreenplayDetailUseCase _getDetail;
  final ForkScreenplayUseCase _fork;
  final FavoriteScreenplayUseCase _favorite;
  final String _id;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getDetail(_id);
    if (result is Failure<DisplayTree>) {
      state = state.copyWith(
        isLoading: false,
        error: result.exception.toString(),
      );
      return;
    }
    state = state.copyWith(
      detail: (result as Success<DisplayTree>).data,
      isLoading: false,
    );
  }

  void selectTab(int index) => state = state.copyWith(selectedTab: index);

  Future<int?> fork() async {
    state = state.copyWith(isForking: true);
    final result = await _fork(_id);
    state = state.copyWith(isForking: false);
    if (result is Failure<int>) return null;
    return (result as Success<int>).data;
  }

  Future<void> favorite() async {
    await _favorite(_id);
  }
}

final screenplayDetailProvider = StateNotifierProvider.family<
    ScreenplayDetailNotifier, ScreenplayDetailState, String>((ref, id) {
  return ScreenplayDetailNotifier(
    ref.watch(getScreenplayDetailUseCaseProvider),
    ref.watch(forkScreenplayUseCaseProvider),
    ref.watch(favoriteScreenplayUseCaseProvider),
    id,
  );
});
