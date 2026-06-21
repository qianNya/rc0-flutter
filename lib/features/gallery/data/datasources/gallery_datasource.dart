import 'package:rc0_flutter/features/gallery/domain/entities/gallery_image.dart';

abstract class GalleryDatasource {
  Future<List<GalleryImage>> getImages({String? filter});
  Future<List<GalleryImage>> getWorks();
  Future<List<String>> getTags();
}
