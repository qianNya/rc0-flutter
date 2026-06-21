class GalleryImage {
  const GalleryImage({
    required this.id,
    required this.imageUrl,
    required this.width,
    required this.height,
    this.resolution,
    this.tag,
  });

  final String id;
  final String imageUrl;
  final int width;
  final int height;
  final String? resolution;
  final String? tag;
}
