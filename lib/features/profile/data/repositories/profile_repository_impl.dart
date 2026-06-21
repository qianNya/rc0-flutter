import 'package:rc0_flutter/core/error/app_exception.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/profile/data/datasources/profile_datasource.dart';
import 'package:rc0_flutter/features/profile/domain/entities/user_profile.dart';
import 'package:rc0_flutter/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._datasource);

  final ProfileDatasource _datasource;

  @override
  Future<Result<UserProfile>> getCurrentUserProfile() async {
    try {
      return Success(await _datasource.getCurrentUserProfile());
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }
}
