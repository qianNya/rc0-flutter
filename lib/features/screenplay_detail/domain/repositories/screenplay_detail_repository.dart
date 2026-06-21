import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/display_tree.dart';

abstract class ScreenplayDetailRepository {
  Future<Result<DisplayTree>> getDetail(String id);
  Future<Result<int>> fork(String id);
  Future<Result<void>> favorite(String id);
}
