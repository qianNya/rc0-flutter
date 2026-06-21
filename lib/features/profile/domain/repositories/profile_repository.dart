import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/profile/domain/entities/user_profile.dart';

abstract class ProfileRepository {
  Future<Result<UserProfile>> getCurrentUserProfile();
}
