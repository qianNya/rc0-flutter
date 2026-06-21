import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/template_detail/domain/entities/template_detail.dart';
import 'package:rc0_flutter/features/template_detail/domain/repositories/template_detail_repository.dart';

class GetTemplateDetailUseCase {
  const GetTemplateDetailUseCase(this._repository);

  final TemplateDetailRepository _repository;

  Future<Result<TemplateDetail>> call(String id) {
    return _repository.getTemplateDetail(id);
  }
}
