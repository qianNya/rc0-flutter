class UserWork {
  const UserWork({
    required this.id,
    required this.title,
    required this.coverUrl,
  });

  final String id;
  final String title;
  final String coverUrl;
}

class UserProfile {
  const UserProfile({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.coverUrl,
    required this.level,
    required this.bio,
    required this.worksCount,
    required this.followersCount,
    required this.followingCount,
    required this.likesCount,
    required this.works,
  });

  final String id;
  final String name;
  final String avatarUrl;
  final String coverUrl;
  final int level;
  final String bio;
  final int worksCount;
  final int followersCount;
  final int followingCount;
  final int likesCount;
  final List<UserWork> works;
}
