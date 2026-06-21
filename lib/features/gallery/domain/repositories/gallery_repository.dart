import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/gallery/domain/entities/gallery_image.dart';

abstract class GalleryRepository {
  Future<Result<List<GalleryImage>>> getImages({String? filter});
  Future<Result<List<GalleryImage>>> getWorks();
  Future<Result<List<String>>> getTags();
}
