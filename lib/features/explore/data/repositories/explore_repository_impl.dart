import 'package:rc0_flutter/core/error/app_exception.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/explore/data/datasources/explore_datasource.dart';
import 'package:rc0_flutter/features/explore/domain/entities/feed_item.dart';
import 'package:rc0_flutter/features/explore/domain/repositories/explore_repository.dart';

class ExploreRepositoryImpl implements ExploreRepository {
  ExploreRepositoryImpl(this._datasource);

  final ExploreDatasource _datasource;

  @override
  Future<Result<List<FeedItem>>> getFeed({String? category}) async {
    try {
      final items = await _datasource.getFeed(category: category);
      return Success(items);
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  @override
  Future<Result<List<FeedItem>>> getRecommendations() async {
    try {
      final items = await _datasource.getRecommendations();
      return Success(items);
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }
}
