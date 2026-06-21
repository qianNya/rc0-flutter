import 'package:rc0_flutter/features/template_market/domain/entities/template_item.dart';
import 'package:rc0_flutter/features/template_market/domain/repositories/template_market_repository.dart';

abstract class TemplateMarketDatasource {
  Future<List<TemplateItem>> getHotTemplates();
  Future<List<String>> getCategories();
  Future<List<MarketBanner>> getBanners();
}
