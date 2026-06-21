enum DraftSourceType {
  localNew('local_new'),
  remoteTemplate('remote_template'),
  fork('fork');

  const DraftSourceType(this.value);

  final String value;

  static DraftSourceType fromValue(String? value) {
    return DraftSourceType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => DraftSourceType.localNew,
    );
  }
}
