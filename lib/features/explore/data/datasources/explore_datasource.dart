import 'package:rc0_flutter/features/explore/domain/entities/feed_item.dart';

abstract class ExploreDatasource {
  Future<List<FeedItem>> getFeed({String? category});
  Future<List<FeedItem>> getRecommendations();
}
