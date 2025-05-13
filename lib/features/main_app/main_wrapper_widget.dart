import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';

import '../../common/bloc/locale_notifier.dart';
import '../../common/e_supported_localizations.dart';
import '../../common/reactive/react_widget.dart';
import '../../common/theme/toloka_fonts.dart';
import '../../common/widgets/app_icon.dart';
import '../../common/widgets/toloka_snackbar.dart';
import '../../data/models/ui/popup_model.dart';
import '../../data/service/snackbar_service.dart';
import '../admin/complaints/bloc/complaints_admin_bloc.dart';
import '../admin/complaints/bloc/complaints_admin_event.dart';
import '../admin/complaints/complaints_screen.dart';
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
                TolokaSnackbar.show(ctx, snapshot.data!);
              });
            }
            return StreamBuilder<PopupModel>(
              stream: GetIt.I<SnackbarService>().popupStream,
              builder: (final ctx, final snapshot) {
                if (snapshot.hasData) {
                  SchedulerBinding.instance.addPostFrameCallback((final _) {
                    TolokaSnackbar.show(ctx, snapshot.data!);
                  });
                }
                return Stack(
                  children: [
                    if (child != null) child!,
                    Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ReactWidget(
                            stream: context.read<UserBloc>().userStream,
                            builder: (final user) => Visibility(
                              visible: user.valueOrNull?.isAdmin ?? false,
                              child: IconButton(
                                onPressed: () => showModalBottomSheet(
                                  isScrollControlled: true,
                                  useSafeArea: true,
                                  showDragHandle: true,
                                  context: MainApp
                                      .navigatorKey.currentState!.context,
                                  builder: (final context) => BlocProvider(
                                    create: (final context) =>
                                        ComplaintsAdminBloc(GetIt.I)
                                          ..add(
                                            const GetComplaintsAdminEvent(),
                                          ),
                                    child: const ComplaintsScreen(),
                                  ),
                                ),
                                icon: Badge(
                                  backgroundColor: Colors.red,
                                  label: Text(
                                    ' ',
                                    style: TolokaFonts.tiny.style.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 5,
                                    ),
                                  ),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    child: Icon(
                                      Icons.report_rounded,
                                      color: Colors.red.withValues(alpha: 0.6),
                                      size: 40,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const AppIcon(),
                            onPressed: () => _showLanguageDialog(
                              MainApp.navigatorKey.currentState!.context,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _showLanguageDialog(final BuildContext context) {
    final notifier = context.read<LocaleNotifier>();
    showAboutDialog(
      context: context,
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
                      style: TolokaFonts.medium.style
                          .copyWith(color: Colors.black),
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
