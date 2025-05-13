import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

import '../../../common/bloc/toloka_bloc.dart';

class MainScreenBloc extends TolokaBloc {
  void readWarning() {
    _isWarningRead.add(true);
  }

  ValueStream<bool> get isWarningRead => _isWarningRead.stream;

  final BehaviorSubject<bool> _isWarningRead =
      BehaviorSubject<bool>.seeded(false);

  @override
  Future<void> dispose() async {
    await super.dispose();
  }
}
