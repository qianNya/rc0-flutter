import 'package:rc0_flutter/core/network/dto/author_summary_dto.dart';
import 'package:rc0_flutter/core/network/dto/sp_screenplay_dto.dart';
import 'package:rc0_flutter/features/explore/domain/entities/feed_item.dart';

class FeedItemDto {
  const FeedItemDto({
    required this.itemType,
    required this.screenplay,
    required this.author,
  });

  final String itemType;
  final SpScreenplayDto screenplay;
  final AuthorSummaryDto author;

  factory FeedItemDto.fromJson(Map<String, dynamic> json) {
    return FeedItemDto(
      itemType: json['item_type'] as String? ?? 'screenplay',
      screenplay: SpScreenplayDto.fromJson(
        json['screenplay'] as Map<String, dynamic>,
      ),
      author: AuthorSummaryDto.fromJson(
        json['author'] as Map<String, dynamic>,
      ),
    );
  }

  FeedItem toEntity() {
    return FeedItem(
      id: '${screenplay.id}',
      title: screenplay.title,
      coverUrl: screenplay.coverUrl ?? '',
      authorName: author.nickname,
      authorAvatarUrl: author.avatar,
      likes: screenplay.likeCount,
      comments: screenplay.commentCount,
    );
  }
}
