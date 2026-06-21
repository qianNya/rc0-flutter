import 'package:rc0_flutter/features/screenplay/data/datasources/screenplay_datasource.dart';
import 'package:rc0_flutter/features/template_detail/data/datasources/template_detail_datasource.dart';
import 'package:rc0_flutter/features/template_detail/domain/entities/template_detail.dart';

class RemoteTemplateDetailDatasource implements TemplateDetailDatasource {
  RemoteTemplateDetailDatasource(this._screenplayDatasource);

  final ScreenplayDatasource _screenplayDatasource;

  @override
  Future<TemplateDetail> getTemplateDetail(String id) async {
    final remoteId = int.parse(id);
    final detail = await _screenplayDatasource.getDetail(remoteId);
    final tree = await _screenplayDatasource.getTree(remoteId);

    final acts = tree.acts.map((actDto) {
      return ActItem(
        id: '${actDto.act.id}',
        title: actDto.act.title,
        scenes: actDto.scenes.map((sceneDto) {
          final firstFrame = sceneDto.frames.isNotEmpty
              ? sceneDto.frames.first
              : null;
          return SceneItem(
            id: '${sceneDto.scene.id}',
            title: sceneDto.scene.title,
            frameCount: sceneDto.frames.length,
            thumbnailUrl: firstFrame?.thumbnailUrl ?? firstFrame?.imageUrl,
          );
        }).toList(),
      );
    }).toList();

    return TemplateDetail(
      id: id,
      title: detail.screenplay.title,
      coverUrl: detail.screenplay.coverUrl ?? '',
      authorName: detail.author.nickname,
      authorAvatarUrl: detail.author.avatar,
      authorLevel: 1,
      likes: detail.screenplay.likeCount,
      comments: detail.screenplay.commentCount,
      views: detail.screenplay.viewCount,
      tags: detail.tags.map((t) => t.name).toList(),
      acts: acts,
    );
  }
}
