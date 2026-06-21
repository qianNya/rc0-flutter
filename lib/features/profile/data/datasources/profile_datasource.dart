import 'package:rc0_flutter/features/profile/domain/entities/user_profile.dart';

abstract class ProfileDatasource {
  Future<UserProfile> getCurrentUserProfile();
}
