import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/screenplay_detail/domain/repositories/screenplay_detail_repository.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/display_tree.dart';

class GetScreenplayDetailUseCase {
  const GetScreenplayDetailUseCase(this._repository);

  final ScreenplayDetailRepository _repository;

  Future<Result<DisplayTree>> call(String id) => _repository.getDetail(id);
}

class ForkScreenplayUseCase {
  const ForkScreenplayUseCase(this._repository);

  final ScreenplayDetailRepository _repository;

  Future<Result<int>> call(String id) => _repository.fork(id);
}

class FavoriteScreenplayUseCase {
  const FavoriteScreenplayUseCase(this._repository);

  final ScreenplayDetailRepository _repository;

  Future<Result<void>> call(String id) => _repository.favorite(id);
}
