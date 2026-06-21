import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/constants/explore_categories.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/explore/data/datasources/explore_datasource_provider.dart';
import 'package:rc0_flutter/features/explore/data/repositories/explore_repository_impl.dart';
import 'package:rc0_flutter/features/explore/domain/entities/feed_item.dart';
import 'package:rc0_flutter/features/explore/domain/repositories/explore_repository.dart';
import 'package:rc0_flutter/features/explore/domain/usecases/get_explore_feed_usecase.dart';

final exploreRepositoryProvider = Provider<ExploreRepository>((ref) {
  return ExploreRepositoryImpl(ref.watch(exploreDatasourceProvider));
});

final getExploreFeedUseCaseProvider = Provider<GetExploreFeedUseCase>((ref) {
  return GetExploreFeedUseCase(ref.watch(exploreRepositoryProvider));
});

final getRecommendationsUseCaseProvider = Provider<GetRecommendationsUseCase>((
  ref,
) {
  return GetRecommendationsUseCase(ref.watch(exploreRepositoryProvider));
});

final exploreCategoriesProvider = Provider<List<String>>(
  (ref) => ExploreCategories.list,
);

class ExploreState {
  const ExploreState({
    this.feedItems = const [],
    this.recommendations = const [],
    this.selectedCategory = '推荐',
    this.isLoading = false,
    this.error,
  });

  final List<FeedItem> feedItems;
  final List<FeedItem> recommendations;
  final String selectedCategory;
  final bool isLoading;
  final String? error;

  ExploreState copyWith({
    List<FeedItem>? feedItems,
    List<FeedItem>? recommendations,
    String? selectedCategory,
    bool? isLoading,
    String? error,
  }) {
    return ExploreState(
      feedItems: feedItems ?? this.feedItems,
      recommendations: recommendations ?? this.recommendations,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ExploreNotifier extends StateNotifier<ExploreState> {
  ExploreNotifier(this._getFeed, this._getRecommendations)
    : super(const ExploreState()) {
    load();
  }

  final GetExploreFeedUseCase _getFeed;
  final GetRecommendationsUseCase _getRecommendations;

  Future<void> load({String? category}) async {
    state = state.copyWith(isLoading: true, error: null);
    final feedResult = await _getFeed(category: category ?? state.selectedCategory);
    final recResult = await _getRecommendations();

    if (feedResult is Failure<List<FeedItem>>) {
      state = state.copyWith(
        isLoading: false,
        error: feedResult.exception.toString(),
      );
      return;
    }

    final recommendations = recResult is Success<List<FeedItem>>
        ? recResult.data
        : <FeedItem>[];

    state = state.copyWith(
      feedItems: (feedResult as Success<List<FeedItem>>).data,
      recommendations: recommendations,
      selectedCategory: category ?? state.selectedCategory,
      isLoading: false,
    );
  }

  void selectCategory(String category) => load(category: category);
}

final exploreProvider = StateNotifierProvider<ExploreNotifier, ExploreState>((
  ref,
) {
  return ExploreNotifier(
    ref.watch(getExploreFeedUseCaseProvider),
    ref.watch(getRecommendationsUseCaseProvider),
  );
});
