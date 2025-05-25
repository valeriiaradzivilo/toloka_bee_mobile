import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AdminCancelButton extends StatelessWidget {
  const AdminCancelButton({super.key});

  @override
  Widget build(final BuildContext context) => TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text(translate('common.cancel')),
      );
}

Future<void> showAdminConfirmDialog({
  required final BuildContext context,
  required final String title,
  required final String content,
  required final VoidCallback onConfirm,
}) =>
    showDialog(
      context: context,
      builder: (final ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          const AdminCancelButton(),
          TextButton(
            onPressed: () {
              onConfirm();
              Navigator.of(ctx).pop();
            },
            child: Text(translate('common.confirm')),
          ),
        ],
      ),
    );
