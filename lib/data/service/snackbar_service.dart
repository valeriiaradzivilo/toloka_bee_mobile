import 'dart:async';

import 'package:flutter/scheduler.dart';

import '../../common/widgets/toloka_snackbar.dart';
import '../../features/main_app/main_app.dart';
import '../models/ui/popup_model.dart';

class SnackbarService {
  SnackbarService._internal() {
    _popupController = StreamController<PopupModel>.broadcast();

    popupStream.listen((final data) {
      SchedulerBinding.instance.addPostFrameCallback((final _) {
        TolokaSnackbar.show(
          MainApp.navigatorKey.currentState!.context,
          data,
        );
      });
    });
  }

  static final SnackbarService _instance = SnackbarService._internal();

  factory SnackbarService() => _instance;

  late final StreamController<PopupModel> _popupController;

  Stream<PopupModel> get popupStream => _popupController.stream;

  void show(final PopupModel model) {
    _popupController.add(model);
  }

  void dispose() {
    _popupController.close();
  }
}
