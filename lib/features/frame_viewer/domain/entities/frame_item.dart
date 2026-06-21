class FrameItem {
  const FrameItem({
    required this.id,
    required this.localId,
    required this.imageUrl,
    this.thumbnailUrl,
    this.title = '',
    this.durationSec = 3,
    this.index = 0,
  });

  final String id;
  final String localId;
  final String? imageUrl;
  final String? thumbnailUrl;
  final String title;
  final int durationSec;
  final int index;
}
