import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_asset.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_nodes.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/screenplay_draft_manifest.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/enums/draft_source_type.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/enums/sync_state.dart';
import 'package:uuid/uuid.dart';

class DraftStorageService {
  DraftStorageService({Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Uuid _uuid;
  String? _draftsRoot;

  Future<String> get draftsRoot async {
    if (_draftsRoot != null) return _draftsRoot!;
    final docs = await getApplicationDocumentsDirectory();
    _draftsRoot = p.join(docs.path, 'drafts');
    return _draftsRoot!;
  }

  Future<String> draftDirectory(String draftId) async {
    final root = await draftsRoot;
    return p.join(root, draftId);
  }

  Future<bool> exists(String draftId) async {
    final file = File(p.join(await draftDirectory(draftId), 'manifest.json'));
    return file.existsSync();
  }

  Future<ScreenplayDraftManifest> create({
    String? title,
    String? draftId,
  }) async {
    final id = draftId ?? _uuid.v4();
    final now = DateTime.now().toUtc();
    final manifest = ScreenplayDraftManifest(
      draftId: id,
      source: const DraftSource(type: DraftSourceType.localNew),
      sync: DraftSyncMeta(
        state: SyncState.localOnly,
        lastLocalSaveAt: now,
        pendingUpload: true,
      ),
      screenplay: DraftScreenplay(
        localId: 'sp-${_uuid.v4()}',
        localModifiedAt: now,
        data: DraftScreenplayData(title: title ?? '未命名剧本'),
      ),
      acts: [
        DraftAct(
          localId: 'act-${_uuid.v4()}',
          localModifiedAt: now,
          data: const DraftActData(title: '开场', sort: 1),
          scenes: [
            DraftScene(
              localId: 'scene-${_uuid.v4()}',
              localModifiedAt: now,
              data: const DraftSceneData(title: '场次 1', sort: 1),
            ),
          ],
        ),
      ],
    );
    await save(manifest);
    return manifest;
  }

  Future<ScreenplayDraftManifest> load(String draftId) async {
    final file = File(p.join(await draftDirectory(draftId), 'manifest.json'));
    if (!file.existsSync()) {
      throw StateError('Draft not found: $draftId');
    }
    final json = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
    return ScreenplayDraftManifest.fromJson(json);
  }

  Future<void> save(ScreenplayDraftManifest manifest) async {
    final dir = await draftDirectory(manifest.draftId);
    await Directory(p.join(dir, 'assets', 'frames')).create(recursive: true);
    await Directory(p.join(dir, 'assets')).create(recursive: true);

    final now = DateTime.now().toUtc();
    final updated = manifest.copyWith(
      sync: manifest.sync.copyWith(
        lastLocalSaveAt: now,
        pendingUpload: true,
        state: manifest.screenplay.remoteId == null
            ? SyncState.localOnly
            : SyncState.dirty,
      ),
    );

    final file = File(p.join(dir, 'manifest.json'));
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert(updated.toJson()),
    );
  }

  Future<String> draftRootFor(String draftId) => draftDirectory(draftId);

  Future<String> registerLocalAsset({
    required String draftId,
    required String assetRef,
    required DraftAssetKind kind,
    required File sourceFile,
    String? relativePath,
  }) async {
    final dir = await draftDirectory(draftId);
    final rel = relativePath ??
        p.join('assets', kind == DraftAssetKind.cover ? 'cover.jpg' : 'frames/$assetRef.jpg');
    final dest = File(p.join(dir, rel));
    await dest.parent.create(recursive: true);
    await sourceFile.copy(dest.path);

    final bytes = await dest.readAsBytes();
    final checksum = 'sha256:${sha256.convert(bytes)}';

    return rel;
  }

  Future<List<String>> listDraftIds() async {
    final root = Directory(await draftsRoot);
    if (!root.existsSync()) return [];
    return root
        .listSync()
        .whereType<Directory>()
        .where((d) => File(p.join(d.path, 'manifest.json')).existsSync())
        .map((d) => p.basename(d.path))
        .toList();
  }

  String newLocalId(String prefix) => '$prefix-${_uuid.v4()}';
  String newAssetRef(String prefix) => 'asset-$prefix-${_uuid.v4().substring(0, 8)}';
}
