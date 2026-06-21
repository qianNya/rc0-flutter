import 'package:rc0_flutter/core/network/api_response.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/core/network/dto/feed_item_dto.dart';
import 'package:rc0_flutter/core/network/dto/page_data_mapper.dart';
import 'package:rc0_flutter/features/profile/data/datasources/profile_datasource.dart';
import 'package:rc0_flutter/features/profile/domain/entities/user_profile.dart';

class RemoteProfileDatasource implements ProfileDatasource {
  RemoteProfileDatasource(this._client);

  final DioClient _client;

  @override
  Future<UserProfile> getCurrentUserProfile() async {
    final response = await _client.dio.get<Map<String, dynamic>>('/users/me');
    final envelope = ApiResponse.fromJson(response.data!, null);
    final data = envelope.requireData() as Map<String, dynamic>;
    final user = data['user'] as Map<String, dynamic>;
    final profile = data['profile'] as Map<String, dynamic>;
    final userId = user['id'] as int;

    final worksResponse = await _client.dio.get<Map<String, dynamic>>(
      '/users/$userId/screenplays',
      queryParameters: {'page': 1, 'page_size': 20, 'publish_status': 1},
    );
    final worksEnvelope = ApiResponse.fromJson(worksResponse.data!, null);
    final feedItems = parsePageItems(
      worksEnvelope.data,
      FeedItemDto.fromJson,
    );

    return UserProfile(
      id: '$userId',
      name: user['nickname'] as String? ?? user['username'] as String? ?? '',
      avatarUrl: user['avatar'] as String? ?? '',
      coverUrl: user['avatar'] as String? ?? '',
      level: profile['level'] as int? ?? 1,
      bio: profile['bio'] as String? ?? '',
      worksCount: profile['screenplay_count'] as int? ?? 0,
      followersCount: profile['follower_count'] as int? ?? 0,
      followingCount: profile['following_count'] as int? ?? 0,
      likesCount: profile['total_likes'] as int? ?? 0,
      works: feedItems
          .map(
            (item) => UserWork(
              id: '${item.screenplay.id}',
              title: item.screenplay.title,
              coverUrl: item.screenplay.coverUrl ?? '',
            ),
          )
          .toList(),
    );
  }
}
