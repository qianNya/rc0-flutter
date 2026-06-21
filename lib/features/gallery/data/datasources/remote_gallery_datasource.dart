import 'package:rc0_flutter/core/network/api_response.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/core/network/dto/image_response_dto.dart';
import 'package:rc0_flutter/core/network/dto/page_data_mapper.dart';
import 'package:rc0_flutter/features/gallery/data/datasources/gallery_datasource.dart';
import 'package:rc0_flutter/features/gallery/domain/entities/gallery_image.dart';

class RemoteGalleryDatasource implements GalleryDatasource {
  RemoteGalleryDatasource(this._client);

  final DioClient _client;

  @override
  Future<List<GalleryImage>> getImages({String? filter}) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/images',
      queryParameters: {'page': 1, 'page_size': 50},
    );
    final envelope = ApiResponse.fromJson(response.data!, null);
    final dtos = parsePageItems(
      envelope.data,
      ImageResponseDto.fromJson,
    );
    return dtos.map(_mapImage).toList();
  }

  @override
  Future<List<GalleryImage>> getWorks() async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/works',
      queryParameters: {'page': 1, 'page_size': 50},
    );
    final envelope = ApiResponse.fromJson(response.data!, null);
    final raw = envelope.data;
    if (raw is List<dynamic>) {
      return raw
          .map((e) => _mapWork(e as Map<String, dynamic>))
          .toList();
    }
    if (raw is Map<String, dynamic>) {
      return parsePageItems(raw, _mapWork).toList();
    }
    return [];
  }

  @override
  Future<List<String>> getTags() async {
    final response = await _client.dio.get<Map<String, dynamic>>('/image-tags');
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

  GalleryImage _mapImage(ImageResponseDto dto) {
    return GalleryImage(
      id: '${dto.id}',
      imageUrl: dto.displayUrl ?? '',
      width: dto.width,
      height: dto.height,
      resolution: '${dto.width}x${dto.height}',
    );
  }

  GalleryImage _mapWork(Map<String, dynamic> json) {
    final cover = json['cover_url'] as String? ?? json['url'] as String? ?? '';
    return GalleryImage(
      id: '${json['id']}',
      imageUrl: cover,
      width: json['width'] as int? ?? 400,
      height: json['height'] as int? ?? 300,
      resolution: json['resolution'] as String?,
      tag: json['title'] as String?,
    );
  }
}
