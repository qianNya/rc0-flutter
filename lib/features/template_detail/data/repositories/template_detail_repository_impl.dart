import 'package:rc0_flutter/core/error/app_exception.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/template_detail/data/datasources/template_detail_datasource.dart';
import 'package:rc0_flutter/features/template_detail/domain/entities/template_detail.dart';
import 'package:rc0_flutter/features/template_detail/domain/repositories/template_detail_repository.dart';

class TemplateDetailRepositoryImpl implements TemplateDetailRepository {
  TemplateDetailRepositoryImpl(this._datasource);

  final TemplateDetailDatasource _datasource;

  @override
  Future<Result<TemplateDetail>> getTemplateDetail(String id) async {
    try {
      return Success(await _datasource.getTemplateDetail(id));
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }
}
