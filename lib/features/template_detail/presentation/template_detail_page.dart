import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/features/template_detail/presentation/template_detail_view.dart';

class TemplateDetailPage extends ConsumerWidget {
  const TemplateDetailPage({super.key, required this.templateId});

  final String templateId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TemplateDetailView(templateId: templateId);
  }
}
