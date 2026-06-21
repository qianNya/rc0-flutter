import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/features/screenplay_detail/presentation/screenplay_detail_view.dart';

class ScreenplayDetailPage extends ConsumerWidget {
  const ScreenplayDetailPage({super.key, required this.screenplayId});

  final String screenplayId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScreenplayDetailView(screenplayId: screenplayId);
  }
}
