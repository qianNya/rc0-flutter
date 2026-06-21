import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/constants/gallery_filters.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/gallery/data/datasources/gallery_datasource.dart';
import 'package:rc0_flutter/features/gallery/data/datasources/remote_gallery_datasource.dart';
import 'package:rc0_flutter/features/gallery/data/repositories/gallery_repository_impl.dart';
import 'package:rc0_flutter/features/gallery/domain/entities/gallery_image.dart';
import 'package:rc0_flutter/features/gallery/domain/repositories/gallery_repository.dart';

final galleryDatasourceProvider = Provider<GalleryDatasource>((ref) {
  return RemoteGalleryDatasource(ref.watch(dioClientProvider));
});

final galleryRepositoryProvider = Provider<GalleryRepository>((ref) {
  return GalleryRepositoryImpl(ref.watch(galleryDatasourceProvider));
});

final galleryFiltersProvider = Provider<List<String>>(
  (ref) => GalleryFilters.list,
);

class GalleryState {
  const GalleryState({
    this.images = const [],
    this.works = const [],
    this.tags = const [],
    this.selectedTab = 0,
    this.selectedFilter = '全部',
    this.isLoading = false,
    this.error,
  });

  final List<GalleryImage> images;
  final List<GalleryImage> works;
  final List<String> tags;
  final int selectedTab;
  final String selectedFilter;
  final bool isLoading;
  final String? error;

  GalleryState copyWith({
    List<GalleryImage>? images,
    List<GalleryImage>? works,
    List<String>? tags,
    int? selectedTab,
    String? selectedFilter,
    bool? isLoading,
    String? error,
  }) {
    return GalleryState(
      images: images ?? this.images,
      works: works ?? this.works,
      tags: tags ?? this.tags,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedFilter: selectedFilter ?? this.selectedFilter,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class GalleryNotifier extends StateNotifier<GalleryState> {
  GalleryNotifier(this._repository) : super(const GalleryState()) {
    load();
  }

  final GalleryRepository _repository;

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    final imagesResult = await _repository.getImages(filter: state.selectedFilter);
    final worksResult = await _repository.getWorks();
    final tagsResult = await _repository.getTags();

    if (imagesResult is Failure<List<GalleryImage>>) {
      state = state.copyWith(
        isLoading: false,
        error: imagesResult.exception.toString(),
      );
      return;
    }

    state = state.copyWith(
      images: (imagesResult as Success<List<GalleryImage>>).data,
      works: worksResult is Success<List<GalleryImage>>
          ? worksResult.data
          : state.works,
      tags: tagsResult is Success<List<String>> ? tagsResult.data : state.tags,
      isLoading: false,
    );
  }

  void selectTab(int index) {
    state = state.copyWith(selectedTab: index);
  }

  void selectFilter(String filter) {
    state = state.copyWith(selectedFilter: filter);
    load();
  }
}

final galleryProvider =
    StateNotifierProvider<GalleryNotifier, GalleryState>((ref) {
  return GalleryNotifier(ref.watch(galleryRepositoryProvider));
});
