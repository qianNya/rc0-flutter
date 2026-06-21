import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/profile/data/datasources/profile_datasource.dart';
import 'package:rc0_flutter/features/profile/data/datasources/remote_profile_datasource.dart';
import 'package:rc0_flutter/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:rc0_flutter/features/profile/domain/entities/user_profile.dart';
import 'package:rc0_flutter/features/profile/domain/repositories/profile_repository.dart';
import 'package:rc0_flutter/features/profile/domain/usecases/get_user_profile_usecase.dart';

final profileDatasourceProvider = Provider<ProfileDatasource>(
  (ref) => RemoteProfileDatasource(ref.watch(dioClientProvider)),
);

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl(ref.watch(profileDatasourceProvider));
});

final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) {
  return GetUserProfileUseCase(ref.watch(profileRepositoryProvider));
});

class ProfileState {
  const ProfileState({
    this.profile,
    this.isLoading = false,
    this.error,
    this.selectedTab = 0,
  });

  final UserProfile? profile;
  final bool isLoading;
  final String? error;
  final int selectedTab;

  ProfileState copyWith({
    UserProfile? profile,
    bool? isLoading,
    String? error,
    int? selectedTab,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier(this._getProfile) : super(const ProfileState()) {
    load();
  }

  final GetUserProfileUseCase _getProfile;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getProfile();
    if (result is Failure<UserProfile>) {
      state = state.copyWith(
        isLoading: false,
        error: result.exception.toString(),
      );
      return;
    }
    state = state.copyWith(
      profile: (result as Success<UserProfile>).data,
      isLoading: false,
    );
  }

  void selectTab(int index) => state = state.copyWith(selectedTab: index);
}

final profileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((
  ref,
) {
  return ProfileNotifier(ref.watch(getUserProfileUseCaseProvider));
});
