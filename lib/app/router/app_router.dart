import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/features/auth/presentation/pages/login_page.dart';
import 'package:rc0_flutter/features/auth/presentation/pages/register_page.dart';
import 'package:rc0_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:rc0_flutter/features/create_wizard/presentation/create_wizard_page.dart';
import 'package:rc0_flutter/features/gallery/presentation/gallery_page.dart';
import 'package:rc0_flutter/features/home/presentation/home_page.dart';
import 'package:rc0_flutter/features/messages/presentation/messages_page.dart';
import 'package:rc0_flutter/features/presets/presentation/presets_page.dart';
import 'package:rc0_flutter/features/profile/presentation/profile_page.dart';
import 'package:rc0_flutter/features/scripts/presentation/script_list_page.dart';
import 'package:rc0_flutter/features/settings/presentation/settings_page.dart';
import 'package:rc0_flutter/features/shell/presentation/main_shell_page.dart';
import 'package:rc0_flutter/features/storyboards/presentation/storyboard_list_page.dart';
import 'package:rc0_flutter/features/users/presentation/users_page.dart';
import 'package:rc0_flutter/features/cine_preset/presentation/cine_preset_page.dart';
import 'package:rc0_flutter/features/frame_viewer/presentation/frame_viewer_page.dart';
import 'package:rc0_flutter/features/screenplay_detail/presentation/screenplay_detail_page.dart';
import 'package:rc0_flutter/features/template_detail/presentation/template_detail_page.dart';
import 'package:rc0_flutter/core/theme/app_theme.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorHomeKey = GlobalKey<NavigatorState>(debugLabel: 'home');
final _shellNavigatorGalleryKey = GlobalKey<NavigatorState>(debugLabel: 'gallery');
final _shellNavigatorCreateKey = GlobalKey<NavigatorState>(debugLabel: 'create');
final _shellNavigatorMessagesKey = GlobalKey<NavigatorState>(debugLabel: 'messages');
final _shellNavigatorProfileKey = GlobalKey<NavigatorState>(debugLabel: 'profile');

final routerProvider = Provider<GoRouter>((ref) {
  final refreshListenable = ValueNotifier<int>(0);
  ref.listen(authProvider, (_, _) {
    refreshListenable.value++;
  });
  ref.onDispose(refreshListenable.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    refreshListenable: refreshListenable,
    redirect: (context, state) {
      final auth = ref.read(authProvider);
      final path = state.uri.path;

      final legacyRedirect = switch (path) {
        AppRoutes.explore => AppRoutes.home,
        AppRoutes.community => AppRoutes.gallery,
        AppRoutes.favorites => AppRoutes.messages,
        _ => null,
      };
      if (legacyRedirect != null) return legacyRedirect;

      final isAuthRoute =
          path == AppRoutes.login || path == AppRoutes.register;
      if (auth.status == AuthStatus.authenticated && isAuthRoute) {
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShellPage(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorHomeKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomePage()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorGalleryKey,
          routes: [
            GoRoute(
              path: AppRoutes.gallery,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: GalleryPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorCreateKey,
          routes: [
            GoRoute(
              path: AppRoutes.create,
              pageBuilder: (context, state) => NoTransitionPage(
                child: Theme(
                  data: AppTheme.light,
                  child: const CreateWizardPage(),
                ),
              ),
            ),
            GoRoute(
              path: AppRoutes.createDraft,
              pageBuilder: (context, state) {
                final draftId = state.pathParameters['draftId']!;
                return NoTransitionPage(
                  child: Theme(
                    data: AppTheme.light,
                    child: CreateWizardPage(draftId: draftId),
                  ),
                );
              },
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorMessagesKey,
          routes: [
            GoRoute(
              path: AppRoutes.messages,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: MessagesPage()),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _shellNavigatorProfileKey,
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfilePage()),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.explore,
      redirect: (context, state) => AppRoutes.home,
    ),
    GoRoute(
      path: AppRoutes.community,
      redirect: (context, state) => AppRoutes.gallery,
    ),
    GoRoute(
      path: AppRoutes.favorites,
      redirect: (context, state) => AppRoutes.messages,
    ),
    GoRoute(
      path: AppRoutes.settings,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.register,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: AppRoutes.scripts,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ScriptListPage(),
    ),
    GoRoute(
      path: AppRoutes.storyboards,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const StoryboardListPage(),
    ),
    GoRoute(
      path: AppRoutes.presets,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const PresetsPage(),
    ),
    GoRoute(
      path: AppRoutes.users,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const UsersPage(),
    ),
    GoRoute(
      path: AppRoutes.templateDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TemplateDetailPage(templateId: id);
      },
      routes: [
        GoRoute(
          path: 'preset',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            return CinePresetPage(templateId: id);
          },
        ),
        GoRoute(
          path: 'frame/:index',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final id = state.pathParameters['id']!;
            final index = int.parse(state.pathParameters['index']!);
            return FrameViewerPage(
              screenplayId: id,
              sceneId: 'legacy',
              initialIndex: index,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.screenplayDetail,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return Theme(
          data: AppTheme.light,
          child: ScreenplayDetailPage(screenplayId: id),
        );
      },
      routes: [
        GoRoute(
          path: 'scene/:sceneId/frame/:frameIndex',
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final screenplayId = state.pathParameters['id']!;
            final sceneId = state.pathParameters['sceneId']!;
            final frameIndex =
                int.parse(state.pathParameters['frameIndex']!);
            return FrameViewerPage(
              screenplayId: screenplayId,
              sceneId: sceneId,
              initialIndex: frameIndex,
            );
          },
        ),
      ],
    ),
  ],
  );
});
