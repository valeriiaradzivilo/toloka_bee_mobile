import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../common/bloc/locale_notifier.dart';
import '../../common/e_supported_localizations.dart';
import '../../common/theme/zip_fonts.dart';
import '../../common/widgets/app_icon.dart';
import '../../common/widgets/zip_snackbar.dart';
import '../../data/models/ui/popup_model.dart';
import '../authentication/bloc/user_bloc.dart';
import 'main_app.dart';

class MainWrapperWidget extends StatelessWidget {
  final Widget? child;
  const MainWrapperWidget(this.child, {super.key});

  @override
  Widget build(final BuildContext context) {
    final localeNotifier = context.watch<LocaleNotifier>();
    final currentCode = localeNotifier.locale?.languageCode;

    return SafeArea(
      key: ValueKey(currentCode),
      child: Material(
        child: StreamBuilder<PopupModel>(
          stream: context.read<UserBloc>().authPopupStream,
          builder: (final ctx, final snapshot) {
            if (snapshot.hasData) {
              SchedulerBinding.instance.addPostFrameCallback((final _) {
                ZipSnackbar.show(ctx, snapshot.data!);
              });
            }
            return Stack(
              children: [
                if (child != null) child!,
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: const AppIcon(),
                    onPressed: () => _showLanguageDialog(context),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showLanguageDialog(final BuildContext context) {
    final notifier = context.read<LocaleNotifier>();
    showAboutDialog(
      context: MainApp.navigatorKey.currentState!.context,
      applicationVersion: 'v1.0.0',
      applicationIcon: const AppIcon(),
      applicationLegalese: translate('app.about'),
      children: [
        DropdownButtonHideUnderline(
          child: DropdownButton<ESupportedLocalizations>(
            value: notifier.locale?.languageCode == 'uk'
                ? ESupportedLocalizations.ukr
                : ESupportedLocalizations.en,
            icon: const Icon(Icons.language),
            onChanged: (final newLocale) {
              if (newLocale != null) {
                notifier.change(newLocale.code);
                Navigator.of(context).pop();
              }
            },
            items: ESupportedLocalizations.values
                .map(
                  (final entry) => DropdownMenuItem(
                    value: entry,
                    child: Text(
                      '${entry.flag} ${entry.text}',
                      style:
                          ZipFonts.medium.style.copyWith(color: Colors.black),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
