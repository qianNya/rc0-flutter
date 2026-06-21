import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/template_market/domain/entities/template_item.dart';

abstract class TemplateMarketRepository {
  Future<Result<List<TemplateItem>>> getHotTemplates();
  Future<Result<List<String>>> getCategories();
  Future<Result<List<MarketBanner>>> getBanners();
}

class MarketBanner {
  const MarketBanner({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final String subtitle;
  final String imageUrl;
}
