import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/template_market/presentation/providers/template_market_provider.dart';
import 'package:rc0_flutter/shared/widgets/template_card.dart';

class CommunityTab extends ConsumerWidget {
  const CommunityTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(templateMarketProvider);

    if (state.isLoading && state.templates.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(templateMarketProvider.notifier).load(),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          100,
        ),
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: AppSpacing.md,
              crossAxisSpacing: AppSpacing.md,
              childAspectRatio: 0.75,
            ),
            itemCount: state.templates.length,
            itemBuilder: (context, index) {
              final item = state.templates[index];
              return TemplateCard(
                item: item,
                onTap: () => context.push(AppRoutes.templateDetailPath(item.id)),
              );
            },
          ),
        ],
      ),
    );
  }
}
