import 'dart:async';

import '../models/ui/popup_model.dart';

class SnackbarService {
  SnackbarService._internal() {
    _popupController = StreamController<PopupModel>.broadcast();
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
