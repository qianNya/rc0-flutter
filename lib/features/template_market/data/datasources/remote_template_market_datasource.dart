import 'package:rc0_flutter/core/network/api_response.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/core/network/dto/feed_item_dto.dart';
import 'package:rc0_flutter/features/screenplay/data/datasources/screenplay_datasource.dart';
import 'package:rc0_flutter/features/template_market/data/datasources/template_market_datasource.dart';
import 'package:rc0_flutter/features/template_market/domain/entities/template_item.dart';
import 'package:rc0_flutter/features/template_market/domain/repositories/template_market_repository.dart';

class RemoteTemplateMarketDatasource implements TemplateMarketDatasource {
  RemoteTemplateMarketDatasource(this._client, this._screenplayDatasource);

  final DioClient _client;
  final ScreenplayDatasource _screenplayDatasource;

  @override
  Future<List<TemplateItem>> getHotTemplates() async {
    final hot = await _screenplayDatasource.listHotTemplates();
    if (hot.isNotEmpty) {
      return hot.map(_mapHotItem).toList();
    }
    final items = await _screenplayDatasource.listTemplates(sort: 'hot');
    return items.map(_mapFeedItem).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final response = await _client.dio.get<Map<String, dynamic>>('/tags');
    final envelope = ApiResponse.fromJson(response.data!, null);
    final raw = envelope.data;
    if (raw is List<dynamic>) {
      return raw.map((e) {
        if (e is Map<String, dynamic>) {
          return e['name'] as String? ?? '$e';
        }
        return e.toString();
      }).toList();
    }
    return [];
  }

  @override
  Future<List<MarketBanner>> getBanners() async {
    final featured = await _screenplayDatasource.listFeatured();
    return featured
        .map(
          (f) => MarketBanner(
            id: '${f.id}',
            title: f.title,
            subtitle: f.subtitle,
            imageUrl: f.bannerUrl,
          ),
        )
        .toList();
  }

  TemplateItem _mapFeedItem(FeedItemDto dto) {
    final sp = dto.screenplay;
    return TemplateItem(
      id: '${sp.id}',
      title: sp.title,
      coverUrl: sp.coverUrl ?? '',
      authorName: dto.author.nickname,
      badge: sp.hotScore != null && sp.hotScore! > 0
          ? TemplateBadge.hot
          : null,
      likes: sp.likeCount,
      comments: sp.commentCount,
    );
  }

  TemplateItem _mapHotItem(SpScreenplayListItem item) {
    return TemplateItem(
      id: '${item.id}',
      title: item.title,
      coverUrl: item.coverUrl ?? '',
      authorName: '',
      badge: item.hotScore != null && item.hotScore! > 0
          ? TemplateBadge.hot
          : null,
      likes: item.likeCount,
      comments: item.commentCount,
    );
  }
}
