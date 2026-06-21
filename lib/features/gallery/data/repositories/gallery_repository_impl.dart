import 'package:rc0_flutter/core/error/app_exception.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/gallery/data/datasources/gallery_datasource.dart';
import 'package:rc0_flutter/features/gallery/domain/entities/gallery_image.dart';
import 'package:rc0_flutter/features/gallery/domain/repositories/gallery_repository.dart';

class GalleryRepositoryImpl implements GalleryRepository {
  GalleryRepositoryImpl(this._datasource);

  final GalleryDatasource _datasource;

  @override
  Future<Result<List<GalleryImage>>> getImages({String? filter}) async {
    try {
      return Success(await _datasource.getImages(filter: filter));
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  @override
  Future<Result<List<GalleryImage>>> getWorks() async {
    try {
      return Success(await _datasource.getWorks());
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  @override
  Future<Result<List<String>>> getTags() async {
    try {
      return Success(await _datasource.getTags());
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }
}
