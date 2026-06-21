import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/explore/domain/entities/feed_item.dart';
import 'package:rc0_flutter/features/explore/domain/repositories/explore_repository.dart';

class GetExploreFeedUseCase {
  const GetExploreFeedUseCase(this._repository);

  final ExploreRepository _repository;

  Future<Result<List<FeedItem>>> call({String? category}) {
    return _repository.getFeed(category: category);
  }
}

class GetRecommendationsUseCase {
  const GetRecommendationsUseCase(this._repository);

  final ExploreRepository _repository;

  Future<Result<List<FeedItem>>> call() {
    return _repository.getRecommendations();
  }
}
