import 'package:rc0_flutter/features/template_detail/domain/entities/template_detail.dart';

abstract class TemplateDetailDatasource {
  Future<TemplateDetail> getTemplateDetail(String id);
}
