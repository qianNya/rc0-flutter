import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/services/asset_resolver.dart';
import 'dart:io';

class DraftImage extends StatelessWidget {
  const DraftImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
  });

  final String? imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;

  static final _resolver = AssetResolver();

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return _placeholder();
    }

    Widget child;
    if (_resolver.isLocalPath(url)) {
      final path = url.startsWith('file://') ? Uri.parse(url).toFilePath() : url;
      child = Image.file(
        File(path),
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    } else {
      child = CachedNetworkImage(
        imageUrl: url,
        fit: fit,
        width: width,
        height: height,
        placeholder: (_, _) => _placeholder(),
        errorWidget: (_, _, _) => _placeholder(),
      );
    }

    if (borderRadius != null) {
      return ClipRRect(borderRadius: borderRadius!, child: child);
    }
    return child;
  }

  Widget _placeholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.searchBarFill,
      child: const Icon(Icons.image_not_supported_outlined, color: AppColors.textSecondary),
    );
  }
}
