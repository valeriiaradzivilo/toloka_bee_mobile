import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zip_way/features/map_screen/bloc/map_screen_bloc.dart';
import 'package:zip_way/features/map_screen/map_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    return Provider(
      create: (_) => MapScreenBloc(),
      dispose: (_, bloc) => bloc.dispose(),
      child: const MapScreen(),
    );
  }
}
