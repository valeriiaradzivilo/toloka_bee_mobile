import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/models/ui/popup_model.dart';
import '../../features/main_app/main_app.dart';
import '../theme/toloka_fonts.dart';

class TolokaSnackbar {
  static final List<OverlayEntry> _entries = [];

  static void show(final BuildContext context, final PopupModel model) {
    final overlayState = MainApp.navigatorKey.currentState?.overlay;
    if (overlayState == null) return;

    final index = _entries.length;

    if (index >= 5) {
      _entries[index - 1].remove();
      _entries.removeAt(index - 1);
    }

    const height = 100.0;
    const spacing = 8.0;

    late final OverlayEntry entry;
    entry = OverlayEntry(
      builder: (final ctx) => Positioned(
        bottom: 16 + index * (height + spacing),
        left: 16,
        right: 16,
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.down,
          onDismissed: (final _) {
            entry.remove();
            _entries.remove(entry);
          },
          child: _NotificationCard(model: model),
        ),
      ),
    );

    overlayState.insert(entry);

    entry.addListener(() {
      if (entry.opaque) {
        entry.remove();
        _entries.remove(entry);
      }
    });
    _entries.add(entry);

    Future.delayed(
      model.onPressed != null
          ? const Duration(seconds: 30)
          : const Duration(seconds: 3),
      () {
        if (_entries.contains(entry)) {
          entry.remove();
          _entries.remove(entry);
        }
      },
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({required this.model});
  final PopupModel model;

  @override
  Widget build(final BuildContext context) => Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Icon(model.type.icon, color: model.type.color),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.title,
                      style: TolokaFonts.medium.style
                          .copyWith(color: Colors.black),
                    ),
                    if (model.message != null && model.message!.isNotEmpty)
                      Text(
                        model.message!,
                        style: TolokaFonts.small.style
                            .copyWith(color: Colors.black54),
                      ),
                  ],
                ),
              ),
              if (model.onPressed != null)
                TextButton(
                  onPressed: () => model.onPressed!(context),
                  child: Text(
                    model.type.actionText,
                    style: TolokaFonts.small.style
                        .copyWith(color: model.type.color),
                  ),
                ),
            ],
          ),
        ),
      );
}
