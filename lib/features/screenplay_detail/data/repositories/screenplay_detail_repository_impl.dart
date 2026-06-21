import 'package:rc0_flutter/core/error/app_exception.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/screenplay/data/datasources/screenplay_datasource.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/mappers/from_server_tree_mapper.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/mappers/to_display_tree_mapper.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/services/draft_storage_service.dart';
import 'package:rc0_flutter/features/screenplay_detail/domain/repositories/screenplay_detail_repository.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/display_tree.dart';

class ScreenplayDetailRepositoryImpl implements ScreenplayDetailRepository {
  ScreenplayDetailRepositoryImpl({
    required DraftStorageService storage,
    required ScreenplayDatasource datasource,
    FromServerTreeMapper? fromServerMapper,
    ToDisplayTreeMapper? toDisplayMapper,
  }) : _storage = storage,
       _datasource = datasource,
       _fromServerMapper = fromServerMapper ?? FromServerTreeMapper(),
       _toDisplayMapper = toDisplayMapper ?? const ToDisplayTreeMapper();

  final DraftStorageService _storage;
  final ScreenplayDatasource _datasource;
  final FromServerTreeMapper _fromServerMapper;
  final ToDisplayTreeMapper _toDisplayMapper;

  @override
  Future<Result<DisplayTree>> getDetail(String id) async {
    try {
      if (await _storage.exists(id)) {
        final manifest = await _storage.load(id);
        final draftRoot = await _storage.draftRootFor(id);
        return Success(_toDisplayMapper(manifest, draftRoot: draftRoot));
      }

      final remoteId = int.tryParse(id);
      if (remoteId == null) {
        return const Failure(UnknownException('无效的剧本 ID'));
      }

      final detail = await _datasource.getDetail(remoteId);
      final tree = await _datasource.getTree(remoteId);
      var manifest = _fromServerMapper(tree, draftId: id);
      manifest = manifest.copyWith(
        authorName: detail.author.nickname,
        authorAvatarUrl: detail.author.avatar,
        likes: detail.screenplay.likeCount,
        comments: detail.screenplay.commentCount,
        views: detail.screenplay.viewCount,
        tags: detail.tags.map((t) => t.name).toList(),
      );
      final draftRoot = await _storage.draftRootFor(manifest.draftId);
      await _storage.save(manifest);
      return Success(_toDisplayMapper(manifest, draftRoot: draftRoot));
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  @override
  Future<Result<int>> fork(String id) async {
    try {
      if (await _storage.exists(id)) {
        final manifest = await _storage.load(id);
        final remoteId = manifest.screenplay.remoteId;
        if (remoteId == null) {
          return const Failure(UnknownException('本地草稿尚未发布，无法 Fork'));
        }
        final forkedId = await _datasource.fork(remoteId);
        return Success(forkedId);
      }
      final remoteId = int.parse(id);
      final forkedId = await _datasource.fork(remoteId);
      return Success(forkedId);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  @override
  Future<Result<void>> favorite(String id) async {
    try {
      final remoteId = await _resolveRemoteId(id);
      if (remoteId == null) {
        return const Failure(UnknownException('无法收藏：剧本尚未同步到服务器'));
      }
      await _datasource.toggleFavorite(remoteId);
      return const Success(null);
    } on AppException catch (e) {
      return Failure(e);
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  Future<int?> _resolveRemoteId(String id) async {
    if (await _storage.exists(id)) {
      final manifest = await _storage.load(id);
      return manifest.screenplay.remoteId;
    }
    return int.tryParse(id);
  }
}
