import 'package:flutter/material.dart';

import '../../data/models/ui/popup_model.dart';
import '../theme/zip_fonts.dart';

class ZipSnackbar extends StatelessWidget {
  const ZipSnackbar({super.key, required this.model});
  final PopupModel model;

  @override
  SnackBar build(final BuildContext context) => SnackBar(
        content: Row(
          spacing: 8,
          children: [
            Icon(
              model.type.icon,
              color: model.type.color,
            ),
            Expanded(
              child: Text(
                model.message,
                style: ZipFonts.medium.style.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: model.type.color.withValues(alpha: 0.1),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      );

  /// Static method to show the custom snackbar
  static void show(final BuildContext context, final PopupModel model) {
    final snackBar = ZipSnackbar(model: model).build(context);

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
