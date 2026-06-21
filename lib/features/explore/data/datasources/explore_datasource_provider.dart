import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/network/dio_client.dart';
import 'package:rc0_flutter/features/explore/data/datasources/explore_datasource.dart';
import 'package:rc0_flutter/features/explore/data/datasources/remote_explore_datasource.dart';

final exploreDatasourceProvider = Provider<ExploreDatasource>((ref) {
  return RemoteExploreDatasource(ref.watch(dioClientProvider));
});
