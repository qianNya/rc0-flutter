class ImageFileResponseDto {
  const ImageFileResponseDto({
    required this.id,
    required this.url,
    this.fileRole,
    this.width,
    this.height,
  });

  final int id;
  final String url;
  final int? fileRole;
  final int? width;
  final int? height;

  factory ImageFileResponseDto.fromJson(Map<String, dynamic> json) {
    return ImageFileResponseDto(
      id: json['id'] as int,
      url: json['url'] as String? ?? '',
      fileRole: json['file_role'] as int?,
      width: json['width'] as int?,
      height: json['height'] as int?,
    );
  }
}

class ImageResponseDto {
  const ImageResponseDto({
    required this.id,
    required this.title,
    this.width = 0,
    this.height = 0,
    this.files = const [],
  });

  final int id;
  final String title;
  final int width;
  final int height;
  final List<ImageFileResponseDto> files;

  factory ImageResponseDto.fromJson(Map<String, dynamic> json) {
    return ImageResponseDto(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      width: json['width'] as int? ?? 0,
      height: json['height'] as int? ?? 0,
      files: (json['files'] as List<dynamic>? ?? [])
          .map((e) => ImageFileResponseDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String? get displayUrl {
    if (files.isEmpty) return null;
    return files.first.url;
  }

  int? get primaryFileId => files.isEmpty ? null : files.first.id;
}
