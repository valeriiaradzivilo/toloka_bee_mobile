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
import '../../main.dart';
import '../authentication/bloc/authentication_bloc.dart';

class MainWrapperWidget extends StatelessWidget {
  const MainWrapperWidget(this.child, {super.key});
  final Widget? child;

  @override
  Widget build(final BuildContext context) {
    final localeNotifier = LocaleNotifier();

    return ChangeNotifierProvider.value(
      value: localeNotifier,
      child: Consumer<LocaleNotifier>(
        builder: (final context, final notifier, final _) => SafeArea(
          key: ValueKey(
            LocalizedApp.of(context).delegate.currentLocale.languageCode,
          ),
          child: Material(
            child: StreamBuilder<PopupModel>(
              stream: context.read<AuthenticationBloc>().authPopupStream,
              builder: (final context, final snapshot) {
                if (snapshot.hasData) {
                  final popup = snapshot.data!;

                  SchedulerBinding.instance.addPostFrameCallback((final _) {
                    ZipSnackbar.show(context, popup);
                  });
                }
                return Stack(
                  children: [
                    if (child != null) child!,
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          final ctx = MyApp.navigatorKey.currentState?.context;
                          if (ctx == null) return;
                          showAboutDialog(
                            context: ctx,
                            applicationVersion: 'v1.0.0',
                            applicationIcon: const AppIcon(),
                            applicationLegalese: translate('app.about'),
                            children: [
                              DropdownButtonHideUnderline(
                                child: DropdownButton<ESupportedLocalizations>(
                                  value: LocalizedApp.of(context)
                                              .delegate
                                              .currentLocale
                                              .languageCode ==
                                          'uk'
                                      ? ESupportedLocalizations.ukr
                                      : ESupportedLocalizations.en,
                                  icon: const Icon(Icons.language),
                                  onChanged: (
                                    final ESupportedLocalizations? newLocale,
                                  ) {
                                    final ctx = MyApp
                                        .navigatorKey.currentState?.context;
                                    if (ctx == null) return;

                                    if (newLocale != null) {
                                      SchedulerBinding.instance
                                          .addPostFrameCallback((final _) {
                                        final localeNotifier =
                                            Provider.of<LocaleNotifier>(
                                          context,
                                          listen: false,
                                        );
                                        localeNotifier.change(newLocale.code);

                                        Navigator.of(ctx).pop();
                                      });
                                    }
                                  },
                                  items: ESupportedLocalizations.values
                                      .map(
                                        (final entry) => DropdownMenuItem<
                                            ESupportedLocalizations>(
                                          value: entry,
                                          child: Text(
                                            '${entry.flag} ${entry.text}',
                                            style:
                                                ZipFonts.medium.style.copyWith(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ],
                          );
                        },
                        icon: const AppIcon(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
