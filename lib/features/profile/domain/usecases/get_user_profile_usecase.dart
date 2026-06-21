import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/profile/domain/entities/user_profile.dart';
import 'package:rc0_flutter/features/profile/domain/repositories/profile_repository.dart';

class GetUserProfileUseCase {
  const GetUserProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserProfile>> call() => _repository.getCurrentUserProfile();
}
