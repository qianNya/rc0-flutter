import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/draft_asset.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/screenplay_draft_manifest.dart';

class AssetResolver {
  const AssetResolver();

  String? resolveDisplayUri(
    ScreenplayDraftManifest manifest,
    String? assetRef, {
    String? draftRoot,
  }) {
    if (assetRef == null) return null;
    final asset = manifest.assets[assetRef];
    if (asset == null) return null;
    return resolveAsset(asset, draftRoot ?? '');
  }

  String? resolveAsset(DraftAsset asset, String draftRoot) {
    if (asset.localUri != null && asset.localUri!.isNotEmpty) {
      if (draftRoot.isNotEmpty) {
        final localPath = p.join(draftRoot, asset.localUri!);
        if (File(localPath).existsSync()) {
          return localPath;
        }
      }
      if (asset.localUri!.startsWith('file://') ||
          asset.localUri!.startsWith('/')) {
        return asset.localUri;
      }
    }
    return asset.remoteUrl;
  }

  bool isLocalPath(String? uri) {
    if (uri == null) return false;
    return uri.startsWith('/') || uri.startsWith('file://');
  }
}
