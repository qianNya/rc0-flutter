import 'package:rc0_flutter/core/network/api_response.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/features/frame_viewer/data/datasources/frame_datasource.dart';
import 'package:rc0_flutter/features/screenplay/data/models/screenplay_tree_dto.dart';

class RemoteFrameDatasource implements FrameDatasource {
  RemoteFrameDatasource(this._client);

  final DioClient _client;

  @override
  Future<List<FrameNodeDto>> getSceneFrames(int sceneRemoteId) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/scenes/$sceneRemoteId/frames',
    );
    final envelope = ApiResponse.fromJson(response.data!, null);
    final raw = envelope.data;
    if (raw is List<dynamic>) {
      return raw
          .map((e) => FrameNodeDto.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<FrameNodeDto> getFrame(int frameId) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/frames/$frameId',
    );
    final envelope = ApiResponse.fromJson(
      response.data!,
      (data) => FrameNodeDto.fromJson(data as Map<String, dynamic>),
    );
    return envelope.requireData();
  }
}
