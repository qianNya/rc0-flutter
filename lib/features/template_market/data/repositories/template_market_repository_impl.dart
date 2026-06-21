import 'package:rc0_flutter/core/error/app_exception.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/template_market/data/datasources/template_market_datasource.dart';
import 'package:rc0_flutter/features/template_market/domain/entities/template_item.dart';
import 'package:rc0_flutter/features/template_market/domain/repositories/template_market_repository.dart';

class TemplateMarketRepositoryImpl implements TemplateMarketRepository {
  TemplateMarketRepositoryImpl(this._datasource);

  final TemplateMarketDatasource _datasource;

  @override
  Future<Result<List<TemplateItem>>> getHotTemplates() async {
    try {
      return Success(await _datasource.getHotTemplates());
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  @override
  Future<Result<List<String>>> getCategories() async {
    try {
      return Success(await _datasource.getCategories());
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  @override
  Future<Result<List<MarketBanner>>> getBanners() async {
    try {
      return Success(await _datasource.getBanners());
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }
}
