import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../common/reactive/react_widget.dart';
import '../../../common/routing/routes.dart';
import '../../../common/theme/toloka_color.dart';
import '../../../common/theme/toloka_fonts.dart';
import '../../../data/models/user_auth_model.dart';
import '../../authentication/bloc/user_bloc.dart';
import '../../give_hand/bloc/give_hand_bloc.dart';
import '../../give_hand/bloc/give_hand_event.dart';
import '../../give_hand/ui/give_hand_screen.dart';
import '../../main_app/main_app.dart';
import '../../request_hand/bloc/create_request_bloc.dart';
import '../../request_hand/bloc/create_request_event.dart';
import '../../request_hand/ui/request_hand_screen.dart';
import 'bloc/map_screen_bloc.dart';
import 'data/location_service_state.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final bloc = context.read<MapScreenBloc>();
    return Scaffold(
      body: ReactWidget3(
        stream1: bloc.locationServiceEnabled,
        stream2: context.read<UserBloc>().isAuthenticated,
        stream3: bloc.volunteerMarkers,
        builder:
            (final locationEnabled, final isAuthenticated, final volunteers) =>
                switch (locationEnabled) {
          LocationServiceState.enabled => Stack(
              children: [
                SizedBox(
                  height: isAuthenticated
                      ? MediaQuery.of(context).size.height * 0.6
                      : null,
                  child: ReactWidget(
                    stream: context.read<UserBloc>().locationStream,
                    builder: (final data) => FlutterMap(
                      key: ValueKey(
                        'Map_Key_${data.latitude}_${data.longitude}',
                      ),
                      mapController: bloc.mapController,
                      options: MapOptions(
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                          pinchMoveWinGestures: MultiFingerGesture.none,
                          pinchZoomWinGestures: MultiFingerGesture.none,
                        ),
                        onPositionChanged: (final camera, final hasGesture) =>
                            bloc.mapController.move(
                          LatLng(data.latitude, data.longitude),
                          12,
                        ),
                        onMapReady: () => bloc.onMapCreated(data),
                        initialZoom: 12,
                        maxZoom: 12,
                        minZoom: 1,
                        keepAlive: true,
                        initialCenter: LatLng(data.latitude, data.longitude),
                      ),
                      children: [
                        TileLayer(
                          key: ValueKey(
                            'Tile_Layer_Map_Key_${data.latitude}_${data.longitude}',
                          ),
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          tileBuilder:
                              (final context, final widget, final tile) =>
                                  widget,
                        ),
                        MarkerLayer(
                          markers: [
                            ...volunteers,
                            Marker(
                              point: LatLng(data.latitude, data.longitude),
                              child: Icon(
                                Icons.person_4_rounded,
                                color: TolokaColor.userRandomColor,
                                size: 50,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: _BottomSheet(),
                ),
              ],
            ),
          LocationServiceState.disabled => Center(
              child: Text(
                translate('location.disabled'),
                style: TolokaFonts.big.error,
              ),
            ),
          LocationServiceState.loading => const Center(
              child: CircularProgressIndicator(
                color: TolokaColor.primary,
              ),
            ),
        },
      ),
    );
  }
}

class _BottomSheet extends StatefulWidget {
  const _BottomSheet();

  @override
  State<_BottomSheet> createState() => _BottomSheetState();
}

class _BottomSheetState extends State<_BottomSheet> with RouteAware {
  @override
  void initState() {
    context.read<UserBloc>().updateUser();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    MainApp.routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    MainApp.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    context.read<UserBloc>().updateUser();
  }

  @override
  Widget build(final BuildContext context) => ReactWidget(
        stream: context.read<UserBloc>().userStream,
        builder: (final user) => Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: TolokaColor.surfaceBright,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: _AccountInfo(user.valueOrNull != null, user.valueOrNull),
              ),
              Visibility(
                visible: user.valueOrNull != null,
                child: Column(
                  children: [
                    const Divider(),
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          translate('map.actions.question'),
                          style: TolokaFonts.medium.style,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                          onPressed: () => showAdaptiveDialog(
                            context: context,
                            builder: (final context) => Dialog(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: TolokaColor.surface,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      translate('map.actions.dialog.header'),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      translate(
                                        'map.actions.dialog.explanation',
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      translate('map.actions.dialog.note.one'),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      translate(
                                        'map.actions.dialog.note.location',
                                      ),
                                    ),
                                    const BackButton(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          icon: const Icon(Icons.info_outline),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              showDragHandle: true,
                              useSafeArea: true,
                              builder: (final context) => BlocProvider(
                                create: (final context) =>
                                    GiveHandBloc(GetIt.instance)
                                      ..add(const GiveHandFetchEvent()),
                                child: const GiveHandScreen(),
                              ),
                            ),
                            label: Text(
                              translate('map.actions.give.hand'),
                              style: TolokaFonts.small.style,
                            ),
                            icon: const Icon(
                              Icons.handshake_outlined,
                              color: TolokaColor.onPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              showDragHandle: true,
                              useSafeArea: true,
                              builder: (final context) => Provider(
                                create: (final _) =>
                                    MapScreenBloc(GetIt.I, context),
                                dispose: (final _, final bloc) =>
                                    bloc.dispose(),
                                child: BlocProvider(
                                  create: (final context) =>
                                      CreateRequestBloc(GetIt.instance)
                                        ..add(const InitCreateRequestEvent()),
                                  child: const RequestHandModal(),
                                ),
                              ),
                            ),
                            label: Text(
                              translate('map.actions.ask.hand'),
                              style: TolokaFonts.small.style,
                            ),
                            icon: const Icon(
                              Icons.volunteer_activism_outlined,
                              color: TolokaColor.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      );
}

class _AccountInfo extends StatelessWidget {
  const _AccountInfo(this.isAuthenticated, this.user);
  final bool isAuthenticated;
  final UserAuthModel? user;

  @override
  Widget build(final BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              InkWell(
                onTap: isAuthenticated
                    ? () =>
                        Navigator.of(context).pushNamed(Routes.profileScreen)
                    : null,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          border:
                              Border.all(color: TolokaColor.primary, width: 2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: user == null || (user!.photo.isEmpty)
                            ? const Icon(
                                Icons.person_4_rounded,
                                size: 50,
                                color: TolokaColor.primary,
                              )
                            : DecoratedBox(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(
                                      base64Decode(user!.photo),
                                    ),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Visibility(
                      visible: isAuthenticated,
                      child: Transform.rotate(
                        angle: 0.3,
                        child: Container(
                          width: 90,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: TolokaColor.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            translate('profile.your'),
                            style: TolokaFonts.tiny.style.copyWith(
                              color: TolokaColor.onPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () => isAuthenticated
                    ? context.read<UserBloc>().logout()
                    : Navigator.of(context)
                        .pushReplacementNamed(Routes.loginScreen),
                child: Text(
                  translate(
                    isAuthenticated
                        ? 'map.actions.logout'
                        : 'map.actions.login',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ReactWidget(
                  stream: context.read<UserBloc>().userStream,
                  builder: (final user) => Text(
                    translate(
                      'map.hello.title',
                      args: {
                        'name': user.valueOrNull != null
                            ? ', ${user.valueOrNull!.name}'
                            : '',
                      },
                    ),
                    style: TolokaFonts.big.style,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Flexible(
                  child: Text(
                    translate('map.hello.subtitle'),
                    style: TolokaFonts.medium.style,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
