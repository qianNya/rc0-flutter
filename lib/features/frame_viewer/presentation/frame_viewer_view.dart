import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/frame_viewer/presentation/providers/frame_viewer_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_immersive_header.dart';
import 'package:rc0_flutter/shared/widgets/draft_image.dart';

class FrameViewerView extends ConsumerWidget {
  const FrameViewerView({
    super.key,
    required this.screenplayId,
    required this.sceneId,
    required this.initialIndex,
  });

  final String screenplayId;
  final String sceneId;
  final int initialIndex;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final params = FrameViewerParams(
      screenplayId: screenplayId,
      sceneId: sceneId,
      initialIndex: initialIndex,
    );
    final state = ref.watch(frameViewerProvider(params));
    final notifier = ref.read(frameViewerProvider(params).notifier);
    final topInset = MediaQuery.paddingOf(context).top;
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (state.frames.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(backgroundColor: Colors.black),
        body: Center(
          child: Text(
            state.error ?? '暂无帧',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }

    final current = state.frames[state.currentIndex];

    return AppImmersiveScope(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          fit: StackFit.expand,
          children: [
            DraftImage(
              imageUrl: current.imageUrl,
              fit: BoxFit.contain,
            ),
            Positioned(
              top: topInset + AppSpacing.sm,
              left: AppSpacing.sm,
              right: AppSpacing.sm,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: Text(
                      '${state.currentIndex + 1}/${state.frames.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            if (state.currentIndex > 0)
              Positioned(
                left: AppSpacing.sm,
                top: 0,
                bottom: 0,
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, color: Colors.white),
                      onPressed: notifier.previous,
                    ),
                  ),
                ),
              ),
            if (state.currentIndex < state.frames.length - 1)
              Positioned(
                right: AppSpacing.sm,
                top: 0,
                bottom: 0,
                child: Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: IconButton(
                      icon: const Icon(Icons.chevron_right, color: Colors.white),
                      onPressed: notifier.next,
                    ),
                  ),
                ),
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: bottomInset + AppSpacing.sm,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 56,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.lg,
                      ),
                      itemCount: state.frames.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(width: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final frame = state.frames[index];
                        final selected = index == state.currentIndex;
                        return GestureDetector(
                          onTap: () => notifier.goTo(index),
                          child: Container(
                            width: 48,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: selected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(AppRadius.sm),
                            ),
                            child: DraftImage(
                              imageUrl: frame.thumbnailUrl ?? frame.imageUrl,
                              borderRadius:
                                  BorderRadius.circular(AppRadius.sm),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ActionIcon(
                        Icons.download_outlined,
                        '下载',
                        onTap: () => _showToast(context, '下载功能即将上线'),
                      ),
                      _ActionIcon(
                        Icons.favorite_border,
                        '收藏',
                        onTap: () => _showToast(context, '收藏功能即将上线'),
                      ),
                      _ActionIcon(
                        Icons.share_outlined,
                        '分享',
                        onTap: () => _showToast(context, '分享功能即将上线'),
                      ),
                      _ActionIcon(
                        Icons.more_horiz,
                        '更多',
                        onTap: () => _showToast(context, '更多功能即将上线'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon(this.icon, this.label, {required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 22),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}
