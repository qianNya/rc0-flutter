abstract final class AppRoutes {
  static const home = '/home';
  static const gallery = '/gallery';
  static const create = '/create';
  static const messages = '/messages';
  static const profile = '/profile';
  static const settings = '/settings';
  static const login = '/login';
  static const register = '/register';
  static const scripts = '/scripts';
  static const storyboards = '/storyboards';
  static const presets = '/presets';
  static const users = '/users';
  static const templateDetail = '/template/:id';
  static const cinePreset = '/template/:id/preset';
  static const screenplayDetail = '/screenplay/:id';
  static const screenplayFrameViewer =
      '/screenplay/:screenplayId/scene/:sceneId/frame/:frameIndex';
  static const createDraft = '/create/:draftId';
  static const frameViewer = '/template/:id/frame/:index';

  // Legacy redirects
  static const explore = '/explore';
  static const community = '/community';
  static const favorites = '/favorites';

  static String templateDetailPath(String id) => '/template/$id';
  static String cinePresetPath(String id) => '/template/$id/preset';
  static String screenplayDetailPath(String id) => '/screenplay/$id';
  static String screenplayFrameViewerPath(
    String screenplayId,
    String sceneId,
    int frameIndex,
  ) =>
      '/screenplay/$screenplayId/scene/$sceneId/frame/$frameIndex';
  static String createDraftPath(String draftId) => '/create/$draftId';
  static String frameViewerPath(String templateId, int index) =>
      '/template/$templateId/frame/$index';
}
