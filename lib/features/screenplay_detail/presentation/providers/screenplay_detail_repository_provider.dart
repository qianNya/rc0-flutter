import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/features/screenplay/presentation/providers/screenplay_providers.dart';
import 'package:rc0_flutter/features/screenplay_detail/data/repositories/screenplay_detail_repository_impl.dart';
import 'package:rc0_flutter/features/screenplay_detail/domain/repositories/screenplay_detail_repository.dart';
import 'package:rc0_flutter/features/screenplay_detail/domain/usecases/screenplay_detail_usecases.dart';

final screenplayDetailRepositoryProvider =
    Provider<ScreenplayDetailRepository>((ref) {
  return ScreenplayDetailRepositoryImpl(
    storage: ref.watch(draftStorageServiceProvider),
    datasource: ref.watch(screenplayDatasourceProvider),
  );
});

final getScreenplayDetailUseCaseProvider =
    Provider<GetScreenplayDetailUseCase>((ref) {
  return GetScreenplayDetailUseCase(
    ref.watch(screenplayDetailRepositoryProvider),
  );
});

final forkScreenplayUseCaseProvider = Provider<ForkScreenplayUseCase>((ref) {
  return ForkScreenplayUseCase(ref.watch(screenplayDetailRepositoryProvider));
});

final favoriteScreenplayUseCaseProvider =
    Provider<FavoriteScreenplayUseCase>((ref) {
  return FavoriteScreenplayUseCase(
    ref.watch(screenplayDetailRepositoryProvider),
  );
});
