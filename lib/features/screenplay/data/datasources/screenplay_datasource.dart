import 'package:rc0_flutter/core/network/dto/engagement_state_dto.dart';
import 'package:rc0_flutter/core/network/dto/feed_item_dto.dart';
import 'package:rc0_flutter/core/network/dto/screenplay_detail_dto.dart';
import 'package:rc0_flutter/features/screenplay/data/models/screenplay_tree_dto.dart';

abstract class CommunityDatasource {
  Future<EngagementStateDto> getEngagement(int screenplayId);
  Future<bool> toggleLike(int screenplayId);
  Future<bool> toggleFavorite(int screenplayId);
  Future<List<Map<String, dynamic>>> listComments(int screenplayId);
}

abstract class ScreenplayDatasource extends CommunityDatasource {
  Future<ScreenplayTreeDto> getTree(int screenplayId);
  Future<ScreenplayDetailDto> getDetail(int screenplayId);
  Future<CreatedNodeDto> createScreenplay(Map<String, dynamic> payload);
  Future<void> updateScreenplay(int screenplayId, Map<String, dynamic> payload);
  Future<CreatedNodeDto> createAct(int screenplayId, Map<String, dynamic> payload);
  Future<CreatedNodeDto> createScene(
    int screenplayId,
    int actId,
    Map<String, dynamic> payload,
  );
  Future<CreatedNodeDto> createFrame(
    int screenplayId,
    int sceneId,
    Map<String, dynamic> payload,
  );
  Future<ImageUploadResultDto> uploadImage(String filePath);
  Future<String> uploadCover(int screenplayId, String filePath);
  Future<void> publish(int screenplayId);
  Future<int> fork(int screenplayId);
  Future<List<FeedItemDto>> listTemplates({String? sort, int? tagId});
  Future<List<SpScreenplayListItem>> listHotTemplates();
  Future<List<FeaturedCollectionDto>> listFeatured();
}

class SpScreenplayListItem {
  const SpScreenplayListItem({
    required this.id,
    required this.title,
    this.coverUrl,
    this.likeCount = 0,
    this.commentCount = 0,
    this.hotScore,
  });

  final int id;
  final String title;
  final String? coverUrl;
  final int likeCount;
  final int commentCount;
  final double? hotScore;

  factory SpScreenplayListItem.fromJson(Map<String, dynamic> json) {
    return SpScreenplayListItem(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      coverUrl: json['cover_url'] as String?,
      likeCount: json['like_count'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? 0,
      hotScore: (json['hot_score'] as num?)?.toDouble(),
    );
  }
}

class FeaturedCollectionDto {
  const FeaturedCollectionDto({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.bannerUrl,
  });

  final int id;
  final String title;
  final String subtitle;
  final String bannerUrl;

  factory FeaturedCollectionDto.fromJson(Map<String, dynamic> json) {
    return FeaturedCollectionDto(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      bannerUrl: json['banner_url'] as String? ?? '',
    );
  }
}
