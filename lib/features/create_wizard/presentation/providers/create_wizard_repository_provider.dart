import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/features/create_wizard/domain/usecases/create_wizard_usecases.dart';
import 'package:rc0_flutter/features/screenplay/presentation/providers/screenplay_providers.dart';

final loadDraftUseCaseProvider = Provider<LoadDraftUseCase>((ref) {
  return LoadDraftUseCase(ref.watch(draftStorageServiceProvider));
});

final saveDraftUseCaseProvider = Provider<SaveDraftUseCase>((ref) {
  return SaveDraftUseCase(ref.watch(draftStorageServiceProvider));
});

final createDraftUseCaseProvider = Provider<CreateDraftUseCase>((ref) {
  return CreateDraftUseCase(ref.watch(draftStorageServiceProvider));
});

final uploadDraftUseCaseProvider = Provider<UploadDraftUseCase>((ref) {
  return UploadDraftUseCase(ref.watch(screenplaySyncServiceProvider));
});
