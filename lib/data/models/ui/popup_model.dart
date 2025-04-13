import 'package:flutter/material.dart';

import 'e_popup_type.dart';

class PopupModel {
  final String title;
  final String? message;
  final String? buttonText;
  final Function(BuildContext context)? onPressed;
  final EPopupType type;

  PopupModel({
    required this.title,
    this.message,
    this.buttonText,
    this.onPressed,
    this.type = EPopupType.info,
  });
}
