import 'package:flutter_test/flutter_test.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/explore/data/datasources/mock_explore_datasource.dart';
import 'package:rc0_flutter/features/explore/data/repositories/explore_repository_impl.dart';

void main() {
  group('ExploreRepositoryImpl', () {
    late ExploreRepositoryImpl repository;

    setUp(() {
      repository = ExploreRepositoryImpl(MockExploreDatasource());
    });

    test('getFeed returns success with items', () async {
      final result = await repository.getFeed();
      expect(result, isA<Success>());
      final items = (result as Success).data as List;
      expect(items, isNotEmpty);
    });

    test('getRecommendations returns success with items', () async {
      final result = await repository.getRecommendations();
      expect(result, isA<Success>());
      final items = (result as Success).data as List;
      expect(items.length, lessThanOrEqualTo(6));
    });
  });
}
