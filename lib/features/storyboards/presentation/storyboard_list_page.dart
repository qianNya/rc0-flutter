import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/template_market/presentation/providers/template_market_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_light_scaffold.dart';
import 'package:cached_network_image/cached_network_image.dart';

class StoryboardListPage extends ConsumerWidget {
  const StoryboardListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(templateMarketProvider);

    return AppLightScaffold(
      appBar: AppBar(title: const Text('分镜列表')),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.lg),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: AppSpacing.md,
          crossAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.8,
        ),
        itemCount: state.templates.length,
        itemBuilder: (context, index) {
          final item = state.templates[index];
          return GestureDetector(
            onTap: () => context.push(AppRoutes.templateDetailPath(item.id)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    child: CachedNetworkImage(
                      imageUrl: item.coverUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
