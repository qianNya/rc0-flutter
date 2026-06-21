abstract final class ExploreCategories {
  static const list = ['推荐', '关注', '最新', '人像', '光影', '情绪'];

  static String? sortForCategory(String category) {
    return switch (category) {
      '推荐' => 'recommend',
      '最新' => 'latest',
      _ => null,
    };
  }
}
