import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/explore/presentation/providers/explore_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_light_scaffold.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';

class ScriptListPage extends ConsumerWidget {
  const ScriptListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreProvider);

    return AppLightScaffold(
      appBar: AppBar(title: const Text('我的剧本')),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppSpacing.lg),
        itemCount: state.feedItems.length,
        separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
        itemBuilder: (context, index) {
          final item = state.feedItems[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.md),
              child: CachedNetworkImage(
                imageUrl: item.coverUrl,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(item.title),
            subtitle: Text(item.authorName),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(AppRoutes.screenplayDetailPath(item.id)),
          );
        },
      ),
    );
  }
}
