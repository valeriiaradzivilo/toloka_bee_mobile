import 'e_popup_type.dart';

class PopupModel {
  final String title;
  final String message;
  final String? buttonText;
  final Function? onPressed;
  final EPopupType type;

  PopupModel({
    required this.title,
    required this.message,
    this.buttonText,
    this.onPressed,
    this.type = EPopupType.info,
  });
}
