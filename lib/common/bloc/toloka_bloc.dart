import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:simple_logger/simple_logger.dart';

abstract class TolokaBloc {
  TolokaBloc() {
    _onCreated();
  }

  @mustBeOverridden
  @mustCallSuper
  Future<void> dispose() async {
    for (final s in _subscriptions) {
      await s.cancel();
    }
  }

  void _onCreated() {
    return;
  }

  void addSubscription(final StreamSubscription subscription) {
    _subscriptions.add(subscription);
  }

  final List<StreamSubscription> _subscriptions = [];

  final logger = SimpleLogger();
}
