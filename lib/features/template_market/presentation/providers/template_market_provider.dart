import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/screenplay/presentation/providers/screenplay_providers.dart';
import 'package:rc0_flutter/features/template_market/data/datasources/remote_template_market_datasource.dart';
import 'package:rc0_flutter/features/template_market/data/datasources/template_market_datasource.dart';
import 'package:rc0_flutter/features/template_market/data/repositories/template_market_repository_impl.dart';
import 'package:rc0_flutter/features/template_market/domain/entities/template_item.dart';
import 'package:rc0_flutter/features/template_market/domain/repositories/template_market_repository.dart';
import 'package:rc0_flutter/features/template_market/domain/usecases/get_hot_templates_usecase.dart';

final templateMarketDatasourceProvider = Provider<TemplateMarketDatasource>(
  (ref) => RemoteTemplateMarketDatasource(
    ref.watch(dioClientProvider),
    ref.watch(screenplayDatasourceProvider),
  ),
);

final templateMarketRepositoryProvider = Provider<TemplateMarketRepository>((ref) {
  return TemplateMarketRepositoryImpl(ref.watch(templateMarketDatasourceProvider));
});

final getHotTemplatesUseCaseProvider = Provider<GetHotTemplatesUseCase>((ref) {
  return GetHotTemplatesUseCase(ref.watch(templateMarketRepositoryProvider));
});

final getMarketBannersUseCaseProvider = Provider<GetMarketBannersUseCase>((ref) {
  return GetMarketBannersUseCase(ref.watch(templateMarketRepositoryProvider));
});

final getMarketCategoriesUseCaseProvider = Provider<GetMarketCategoriesUseCase>((
  ref,
) {
  return GetMarketCategoriesUseCase(ref.watch(templateMarketRepositoryProvider));
});

class TemplateMarketState {
  const TemplateMarketState({
    this.templates = const [],
    this.banners = const [],
    this.categories = const [],
    this.isLoading = false,
    this.error,
  });

  final List<TemplateItem> templates;
  final List<MarketBanner> banners;
  final List<String> categories;
  final bool isLoading;
  final String? error;

  TemplateMarketState copyWith({
    List<TemplateItem>? templates,
    List<MarketBanner>? banners,
    List<String>? categories,
    bool? isLoading,
    String? error,
  }) {
    return TemplateMarketState(
      templates: templates ?? this.templates,
      banners: banners ?? this.banners,
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TemplateMarketNotifier extends StateNotifier<TemplateMarketState> {
  TemplateMarketNotifier(
    this._getTemplates,
    this._getBanners,
    this._getCategories,
  ) : super(const TemplateMarketState()) {
    load();
  }

  final GetHotTemplatesUseCase _getTemplates;
  final GetMarketBannersUseCase _getBanners;
  final GetMarketCategoriesUseCase _getCategories;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    final templatesResult = await _getTemplates();
    final bannersResult = await _getBanners();
    final categoriesResult = await _getCategories();

    if (templatesResult is Failure<List<TemplateItem>>) {
      state = state.copyWith(
        isLoading: false,
        error: templatesResult.exception.toString(),
      );
      return;
    }

    state = state.copyWith(
      templates: (templatesResult as Success<List<TemplateItem>>).data,
      banners: bannersResult is Success<List<MarketBanner>>
          ? bannersResult.data
          : [],
      categories: categoriesResult is Success<List<String>>
          ? categoriesResult.data
          : [],
      isLoading: false,
    );
  }
}

final templateMarketProvider =
    StateNotifierProvider<TemplateMarketNotifier, TemplateMarketState>((ref) {
      return TemplateMarketNotifier(
        ref.watch(getHotTemplatesUseCaseProvider),
        ref.watch(getMarketBannersUseCaseProvider),
        ref.watch(getMarketCategoriesUseCaseProvider),
      );
    });
