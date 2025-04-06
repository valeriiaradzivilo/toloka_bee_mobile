enum ERequestStatus {
  pending,
  inProgress,
  completed,
  failed,
  cancelled,
  unknown;

  static ERequestStatus fromJson(final String json) => values.firstWhere(
        (final element) => element.name == json,
        orElse: () => ERequestStatus.unknown,
      );
}
