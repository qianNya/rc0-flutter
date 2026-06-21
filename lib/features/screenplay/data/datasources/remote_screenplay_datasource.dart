import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rc0_flutter/core/network/api_response.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/core/network/dto/engagement_state_dto.dart';
import 'package:rc0_flutter/core/network/dto/feed_item_dto.dart';
import 'package:rc0_flutter/core/network/dto/image_response_dto.dart';
import 'package:rc0_flutter/core/network/dto/page_data_mapper.dart';
import 'package:rc0_flutter/core/network/dto/screenplay_detail_dto.dart';
import 'package:rc0_flutter/features/screenplay/data/datasources/screenplay_datasource.dart';
import 'package:rc0_flutter/features/screenplay/data/models/screenplay_tree_dto.dart';

class RemoteScreenplayDatasource implements ScreenplayDatasource {
  RemoteScreenplayDatasource(this._client);

  final DioClient _client;

  @override
  Future<ScreenplayTreeDto> getTree(int screenplayId) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/screenplays/$screenplayId/tree',
    );
    final envelope = ApiResponse.fromJson(
      response.data!,
      (data) => ScreenplayTreeDto.fromJson(data as Map<String, dynamic>),
    );
    return envelope.requireData();
  }

  @override
  Future<ScreenplayDetailDto> getDetail(int screenplayId) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/screenplays/$screenplayId/detail',
    );
    final envelope = ApiResponse.fromJson(
      response.data!,
      (data) => ScreenplayDetailDto.fromJson(data as Map<String, dynamic>),
    );
    return envelope.requireData();
  }

  @override
  Future<EngagementStateDto> getEngagement(int screenplayId) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/screenplays/$screenplayId/engagement',
    );
    final envelope = ApiResponse.fromJson(
      response.data!,
      (data) => EngagementStateDto.fromJson(data as Map<String, dynamic>),
    );
    return envelope.requireData();
  }

  @override
  Future<bool> toggleLike(int screenplayId) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/likes/$screenplayId',
    );
    final envelope = ApiResponse.fromJson(response.data!, null);
    final data = envelope.requireData() as Map<String, dynamic>;
    return data['active'] as bool? ?? false;
  }

  @override
  Future<bool> toggleFavorite(int screenplayId) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/favorites/$screenplayId',
    );
    final envelope = ApiResponse.fromJson(response.data!, null);
    final data = envelope.requireData() as Map<String, dynamic>;
    return data['active'] as bool? ?? false;
  }

  @override
  Future<List<Map<String, dynamic>>> listComments(int screenplayId) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/comments/$screenplayId',
      queryParameters: {'page': 1, 'page_size': 50},
    );
    final envelope = ApiResponse.fromJson(response.data!, null);
    return parsePageItems(
      envelope.data,
      (json) => json,
    );
  }

  @override
  Future<CreatedNodeDto> createScreenplay(Map<String, dynamic> payload) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/screenplays',
      data: payload,
    );
    final envelope = ApiResponse.fromJson(
      response.data!,
      (data) => CreatedNodeDto.fromJson(data as Map<String, dynamic>),
    );
    return envelope.requireData();
  }

  @override
  Future<void> updateScreenplay(
    int screenplayId,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.dio.put<Map<String, dynamic>>(
      '/screenplays/$screenplayId',
      data: payload,
    );
    ApiResponse.fromJson(response.data!, (_) => null).requireData();
  }

  @override
  Future<CreatedNodeDto> createAct(
    int screenplayId,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/screenplays/$screenplayId/acts',
      data: payload,
    );
    final envelope = ApiResponse.fromJson(
      response.data!,
      (data) => CreatedNodeDto.fromJson(data as Map<String, dynamic>),
    );
    return envelope.requireData();
  }

  @override
  Future<CreatedNodeDto> createScene(
    int screenplayId,
    int actId,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/screenplays/$screenplayId/acts/$actId/scenes',
      data: payload,
    );
    final envelope = ApiResponse.fromJson(
      response.data!,
      (data) => CreatedNodeDto.fromJson(data as Map<String, dynamic>),
    );
    return envelope.requireData();
  }

  @override
  Future<CreatedNodeDto> createFrame(
    int screenplayId,
    int sceneId,
    Map<String, dynamic> payload,
  ) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/screenplays/$screenplayId/scenes/$sceneId/frames',
      data: payload,
    );
    final envelope = ApiResponse.fromJson(
      response.data!,
      (data) => CreatedNodeDto.fromJson(data as Map<String, dynamic>),
    );
    return envelope.requireData();
  }

  @override
  Future<ImageUploadResultDto> uploadImage(String filePath) async {
    final file = File(filePath);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/images',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    final envelope = ApiResponse.fromJson(
      response.data!,
      (data) => ImageResponseDto.fromJson(data as Map<String, dynamic>),
    );
    final image = envelope.requireData();
    return ImageUploadResultDto(
      id: image.id,
      fileId: image.primaryFileId,
      url: image.displayUrl,
    );
  }

  @override
  Future<String> uploadCover(int screenplayId, String filePath) async {
    final file = File(filePath);
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(file.path),
    });
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/screenplays/$screenplayId/cover',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
    final envelope = ApiResponse.fromJson(
      response.data!,
      (data) => data as Map<String, dynamic>,
    );
    final data = envelope.requireData();
    return data['cover_url'] as String? ?? data['url'] as String? ?? '';
  }

  @override
  Future<void> publish(int screenplayId) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/screenplays/$screenplayId/publish',
    );
    ApiResponse.fromJson(response.data!, (_) => null).requireData();
  }

  @override
  Future<int> fork(int screenplayId) async {
    final response = await _client.dio.post<Map<String, dynamic>>(
      '/screenplays/$screenplayId/fork',
    );
    final envelope = ApiResponse.fromJson(
      response.data!,
      (data) => (data as Map<String, dynamic>)['id'] as int,
    );
    return envelope.requireData();
  }

  @override
  Future<List<FeedItemDto>> listTemplates({String? sort, int? tagId}) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/templates',
      queryParameters: {
        'page': 1,
        'page_size': 20,
        if (sort != null) 'sort': sort,
        if (tagId != null) 'tag_id': tagId,
      },
    );
    final envelope = ApiResponse.fromJson(response.data!, null);
    return parsePageItems(envelope.data, FeedItemDto.fromJson);
  }

  @override
  Future<List<SpScreenplayListItem>> listHotTemplates() async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/templates/hot',
      queryParameters: {'page': 1, 'page_size': 20},
    );
    final envelope = ApiResponse.fromJson(response.data!, null);
    final raw = envelope.data;
    if (raw is List<dynamic>) {
      return raw
          .map((e) => SpScreenplayListItem.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<List<FeaturedCollectionDto>> listFeatured() async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/templates/featured',
    );
    final envelope = ApiResponse.fromJson(response.data!, null);
    final raw = envelope.data;
    if (raw is List<dynamic>) {
      return raw
          .map((e) => FeaturedCollectionDto.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }
}
