class CinePresetItem {
  const CinePresetItem({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.aspectRatio,
    required this.frameRate,
    this.isSelected = false,
  });

  final String id;
  final String name;
  final String thumbnailUrl;
  final String aspectRatio;
  final String frameRate;
  final bool isSelected;
}

class CinePresetDetail {
  const CinePresetDetail({
    required this.aspectRatio,
    required this.frameRate,
    required this.colorSpace,
    required this.lut,
  });

  final String aspectRatio;
  final String frameRate;
  final String colorSpace;
  final String lut;
}
