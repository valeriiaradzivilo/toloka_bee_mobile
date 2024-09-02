abstract class ZipBloc {
  ZipBloc() {
    _onCreated();
  }

  Future<void> dispose();

  void _onCreated() {
    return;
  }
}
