import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/template_detail/domain/entities/template_detail.dart';

abstract class TemplateDetailRepository {
  Future<Result<TemplateDetail>> getTemplateDetail(String id);
}
