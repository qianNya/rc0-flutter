import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/screenplay/presentation/providers/screenplay_providers.dart';
import 'package:rc0_flutter/features/template_detail/data/datasources/remote_template_detail_datasource.dart';
import 'package:rc0_flutter/features/template_detail/data/datasources/template_detail_datasource.dart';
import 'package:rc0_flutter/features/template_detail/data/repositories/template_detail_repository_impl.dart';
import 'package:rc0_flutter/features/template_detail/domain/entities/template_detail.dart';
import 'package:rc0_flutter/features/template_detail/domain/repositories/template_detail_repository.dart';
import 'package:rc0_flutter/features/template_detail/domain/usecases/get_template_detail_usecase.dart';

final templateDetailDatasourceProvider = Provider<TemplateDetailDatasource>(
  (ref) => RemoteTemplateDetailDatasource(
    ref.watch(screenplayDatasourceProvider),
  ),
);

final templateDetailRepositoryProvider = Provider<TemplateDetailRepository>((
  ref,
) {
  return TemplateDetailRepositoryImpl(
    ref.watch(templateDetailDatasourceProvider),
  );
});

final getTemplateDetailUseCaseProvider = Provider<GetTemplateDetailUseCase>((
  ref,
) {
  return GetTemplateDetailUseCase(ref.watch(templateDetailRepositoryProvider));
});

class TemplateDetailState {
  const TemplateDetailState({
    this.detail,
    this.selectedTab = 0,
    this.isLoading = false,
    this.error,
  });

  final TemplateDetail? detail;
  final int selectedTab;
  final bool isLoading;
  final String? error;

  TemplateDetailState copyWith({
    TemplateDetail? detail,
    int? selectedTab,
    bool? isLoading,
    String? error,
  }) {
    return TemplateDetailState(
      detail: detail ?? this.detail,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class TemplateDetailNotifier extends StateNotifier<TemplateDetailState> {
  TemplateDetailNotifier(this._getDetail, this._id)
    : super(const TemplateDetailState()) {
    load();
  }

  final GetTemplateDetailUseCase _getDetail;
  final String _id;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    final result = await _getDetail(_id);
    if (result is Failure<TemplateDetail>) {
      state = state.copyWith(
        isLoading: false,
        error: result.exception.toString(),
      );
      return;
    }
    state = state.copyWith(
      detail: (result as Success<TemplateDetail>).data,
      isLoading: false,
    );
  }

  void selectTab(int index) {
    state = state.copyWith(selectedTab: index);
  }
}

final templateDetailProvider = StateNotifierProvider.family<
    TemplateDetailNotifier, TemplateDetailState, String>((ref, id) {
  return TemplateDetailNotifier(
    ref.watch(getTemplateDetailUseCaseProvider),
    id,
  );
});
