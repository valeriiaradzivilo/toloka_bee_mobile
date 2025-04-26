class UserBlockedException implements Exception {
  final DateTime bannedUntil;

  UserBlockedException(this.bannedUntil);

  @override
  String toString() => 'UserBlockedException: $bannedUntil';
}
