import 'package:rc0_flutter/core/network/api_response.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/features/cine_preset/data/datasources/cine_preset_datasource.dart';
import 'package:rc0_flutter/features/cine_preset/domain/entities/cine_preset.dart';

class RemoteCinePresetDatasource implements CinePresetDatasource {
  RemoteCinePresetDatasource(this._client);

  final DioClient _client;

  @override
  Future<List<CinePresetItem>> getPresets(String templateId) async {
    final categoryId = await _resolveCategoryId(templateId);
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/cine-presets/categories/$categoryId',
    );
    final envelope = ApiResponse.fromJson(response.data!, null);
    final raw = envelope.data;
    if (raw is! List<dynamic>) return [];

    return raw.map((e) {
      final json = e as Map<String, dynamic>;
      final params = json['params'] as Map<String, dynamic>? ?? {};
      return CinePresetItem(
        id: '${json['id']}',
        name: json['name'] as String? ?? '',
        thumbnailUrl: json['thumbnail_url'] as String? ?? '',
        aspectRatio: params['aspect_ratio'] as String? ?? '16:9',
        frameRate: params['frame_rate'] as String? ?? '24 fps',
        isSelected: (json['is_default'] as int? ?? 0) == 1,
      );
    }).toList();
  }

  @override
  Future<CinePresetDetail> getPresetDetail(
    String templateId,
    String presetId,
  ) async {
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/cine-presets/$presetId',
    );
    final envelope = ApiResponse.fromJson(response.data!, null);
    final json = envelope.requireData() as Map<String, dynamic>;
    final params = json['params'] as Map<String, dynamic>? ?? {};
    return CinePresetDetail(
      aspectRatio: params['aspect_ratio'] as String? ?? '16:9',
      frameRate: params['frame_rate'] as String? ?? '24 fps',
      colorSpace: params['color_space'] as String? ?? 'Rec.709',
      lut: params['lut'] as String? ?? '',
    );
  }

  Future<int> _resolveCategoryId(String templateId) async {
    final parsed = int.tryParse(templateId);
    final response = await _client.dio.get<Map<String, dynamic>>(
      '/cine-presets/categories',
    );
    final envelope = ApiResponse.fromJson(response.data!, null);
    final raw = envelope.data;
    if (raw is! List<dynamic> || raw.isEmpty) {
      return parsed ?? 1;
    }
    if (parsed != null) {
      final match = raw.cast<Map<String, dynamic>>().where((c) => c['id'] == parsed);
      if (match.isNotEmpty) return parsed;
    }
    return raw.first['id'] as int;
  }
}
