import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/template_market/domain/entities/template_item.dart';
import 'package:rc0_flutter/features/template_market/domain/repositories/template_market_repository.dart';

class GetHotTemplatesUseCase {
  const GetHotTemplatesUseCase(this._repository);

  final TemplateMarketRepository _repository;

  Future<Result<List<TemplateItem>>> call() => _repository.getHotTemplates();
}

class GetMarketBannersUseCase {
  const GetMarketBannersUseCase(this._repository);

  final TemplateMarketRepository _repository;

  Future<Result<List<MarketBanner>>> call() => _repository.getBanners();
}

class GetMarketCategoriesUseCase {
  const GetMarketCategoriesUseCase(this._repository);

  final TemplateMarketRepository _repository;

  Future<Result<List<String>>> call() => _repository.getCategories();
}
