import 'package:rc0_flutter/core/network/api_response.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/core/network/dto/feed_item_dto.dart';
import 'package:rc0_flutter/core/network/dto/page_data_mapper.dart';
import 'package:rc0_flutter/core/constants/explore_categories.dart';
import 'package:rc0_flutter/features/explore/data/datasources/explore_datasource.dart';
import 'package:rc0_flutter/features/explore/domain/entities/feed_item.dart';

class RemoteExploreDatasource implements ExploreDatasource {
  RemoteExploreDatasource(this._client);

  final DioClient _client;

  @override
  Future<List<FeedItem>> getFeed({String? category}) async {
    final sort = ExploreCategories.sortForCategory(category ?? '推荐');
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/feed',
      queryParameters: {
        'page': 1,
        'page_size': 20,
        if (sort != null) 'sort': sort,
      },
    );
    final envelope = ApiResponse.fromJson(response.data!, null);
    final items = parsePageItems(
      envelope.data,
      (json) => FeedItemDto.fromJson(json).toEntity(),
    );
    return items;
  }

  @override
  Future<List<FeedItem>> getRecommendations() async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/feed',
      queryParameters: {'page': 1, 'page_size': 20, 'sort': 'recommend'},
    );
    final envelope = ApiResponse.fromJson(response.data!, null);
    return parsePageItems(
      envelope.data,
      (json) => FeedItemDto.fromJson(json).toEntity(),
    );
  }
}
