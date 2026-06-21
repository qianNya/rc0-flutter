import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/features/template_market/presentation/template_market_view.dart';

class TemplateMarketPage extends ConsumerWidget {
  const TemplateMarketPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const TemplateMarketView();
  }
}
