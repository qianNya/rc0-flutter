import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/features/screenplay/data/datasources/remote_screenplay_datasource.dart';
import 'package:rc0_flutter/features/screenplay/data/datasources/screenplay_datasource.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/services/draft_storage_service.dart';
import 'package:rc0_flutter/features/screenplay_draft/data/services/screenplay_sync_service.dart';

final draftStorageServiceProvider = Provider<DraftStorageService>((ref) {
  return DraftStorageService();
});

final screenplayDatasourceProvider = Provider<ScreenplayDatasource>((ref) {
  return RemoteScreenplayDatasource(ref.watch(dioClientProvider));
});

final screenplaySyncServiceProvider = Provider<ScreenplaySyncService>((ref) {
  return ScreenplaySyncService(
    datasource: ref.watch(screenplayDatasourceProvider),
    storage: ref.watch(draftStorageServiceProvider),
  );
});
