import 'package:rc0_flutter/core/network/dto/author_summary_dto.dart';
import 'package:rc0_flutter/core/network/dto/engagement_state_dto.dart';
import 'package:rc0_flutter/core/network/dto/sp_screenplay_dto.dart';

class SpTagDto {
  const SpTagDto({required this.id, required this.name});

  final int id;
  final String name;

  factory SpTagDto.fromJson(Map<String, dynamic> json) {
    return SpTagDto(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
    );
  }
}

class ScreenplayDetailDto {
  const ScreenplayDetailDto({
    required this.screenplay,
    required this.author,
    this.tags = const [],
    this.engagement = const EngagementStateDto(),
  });

  final SpScreenplayDto screenplay;
  final AuthorSummaryDto author;
  final List<SpTagDto> tags;
  final EngagementStateDto engagement;

  factory ScreenplayDetailDto.fromJson(Map<String, dynamic> json) {
    return ScreenplayDetailDto(
      screenplay: SpScreenplayDto.fromJson(
        json['screenplay'] as Map<String, dynamic>,
      ),
      author: AuthorSummaryDto.fromJson(
        json['author'] as Map<String, dynamic>,
      ),
      tags: (json['tags'] as List<dynamic>? ?? [])
          .map((e) => SpTagDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      engagement: json['engagement'] != null
          ? EngagementStateDto.fromJson(
              json['engagement'] as Map<String, dynamic>,
            )
          : const EngagementStateDto(),
    );
  }
}
