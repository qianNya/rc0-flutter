enum SyncState {
  localOnly('local_only'),
  dirty('dirty'),
  synced('synced'),
  conflict('conflict');

  const SyncState(this.value);

  final String value;

  static SyncState fromValue(String? value) {
    return SyncState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => SyncState.localOnly,
    );
  }
}

enum AssetSyncState {
  localOnly('local_only'),
  remoteOnly('remote_only'),
  synced('synced');

  const AssetSyncState(this.value);

  final String value;

  static AssetSyncState fromValue(String? value) {
    return AssetSyncState.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AssetSyncState.localOnly,
    );
  }
}
