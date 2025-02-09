import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../common/reactive/react_widget.dart';
import 'bloc/main_screen_bloc.dart';
import 'map_screen/bloc/map_screen_bloc.dart';
import 'map_screen/map_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return SafeArea(
      child: Provider(
        create: (_) => MainScreenBloc(),
        dispose: (_, bloc) => bloc.dispose(),
        child: const _WarningPage(),
      ),
    );
  }
}

class _WarningPage extends StatelessWidget {
  const _WarningPage();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MainScreenBloc>();
    return ReactWidget(
      stream: bloc.isWarningRead,
      builder: (isWarningRead) => isWarningRead
          ? Scaffold(
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(translate('start.app.warning.title')),
                      subtitle: Text(translate('start.app.warning.message')),
                    ),
                    TextButton(
                      onPressed: () => bloc.readWarning(),
                      child: Text(translate('start.app.warning.accept')),
                    )
                  ],
                ),
              ),
            )
          : const _Map(),
    );
  }
}

class _Map extends StatelessWidget {
  const _Map();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => MapScreenBloc(GetIt.I, context),
      dispose: (_, bloc) => bloc.dispose(),
      child: const MapScreen(),
    );
  }
}
