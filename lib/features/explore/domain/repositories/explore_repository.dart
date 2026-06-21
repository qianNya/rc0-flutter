import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/explore/domain/entities/feed_item.dart';

abstract class ExploreRepository {
  Future<Result<List<FeedItem>>> getFeed({String? category});
  Future<Result<List<FeedItem>>> getRecommendations();
}
