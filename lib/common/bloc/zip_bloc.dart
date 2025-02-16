import 'package:simple_logger/simple_logger.dart';

abstract class ZipBloc {
  ZipBloc() {
    _onCreated();
  }

  Future<void> dispose();

  void _onCreated() {
    return;
  }

  final logger = SimpleLogger();
}
