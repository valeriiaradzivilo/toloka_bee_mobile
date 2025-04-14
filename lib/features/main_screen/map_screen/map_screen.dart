import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../common/reactive/react_widget.dart';
import '../../../common/routes.dart';
import '../../../common/theme/zip_color.dart';
import '../../../common/theme/zip_fonts.dart';
import '../../../data/models/user_auth_model.dart';
import '../../authentication/bloc/authentication_bloc.dart';
import '../../give_hand/bloc/give_hand_bloc.dart';
import '../../give_hand/bloc/give_hand_event.dart';
import '../../give_hand/ui/give_hand_screen.dart';
import '../../location_control/bloc/location_control_bloc.dart';
import '../../request_hand/bloc/create_request_bloc.dart';
import '../../request_hand/ui/request_hand.dart';
import 'bloc/map_screen_bloc.dart';
import 'data/location_service_state.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final bloc = context.read<MapScreenBloc>();
    return Scaffold(
      body: ReactWidget(
        stream: bloc.locationServiceEnabled,
        builder: (final locationEnabled) => switch (locationEnabled) {
          LocationServiceState.enabled => Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2,
                  child: ReactWidget(
                    stream: context.read<LocationControlBloc>().locationStream,
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
                            Marker(
                              point: LatLng(data.latitude, data.longitude),
                              child: Icon(
                                FontAwesomeIcons.userNinja,
                                color: ZipColor.randomZipColor,
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
                style: ZipFonts.big.error,
              ),
            ),
          LocationServiceState.loading => const Center(
              child: CircularProgressIndicator(
                color: ZipColor.primary,
              ),
            ),
        },
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet();

  @override
  Widget build(final BuildContext context) => ReactWidget(
        stream: context.read<AuthenticationBloc>().userStream,
        builder: (final user) => Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: ZipColor.surfaceBright,
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
                    const Gap(10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          translate('map.actions.question'),
                          style: ZipFonts.medium.style,
                        ),
                        const Gap(10),
                        IconButton(
                          onPressed: () => showAdaptiveDialog(
                            context: context,
                            builder: (final context) => Dialog(
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: ZipColor.surface,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      translate('map.actions.dialog.header'),
                                    ),
                                    const Gap(10),
                                    Text(
                                      translate(
                                        'map.actions.dialog.explanation',
                                      ),
                                    ),
                                    const Gap(20),
                                    Text(
                                      translate('map.actions.dialog.note.one'),
                                    ),
                                    const Gap(20),
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
                    const Gap(20),
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
                                      ..add(GiveHandFetchEvent()),
                                child: const GiveHandScreen(),
                              ),
                            ),
                            label: Text(
                              translate('map.actions.give.hand'),
                              style: ZipFonts.small.style,
                            ),
                            icon: const Icon(
                              Icons.handshake_outlined,
                              color: ZipColor.onPrimary,
                            ),
                          ),
                        ),
                        const Gap(10),
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
                                      CreateRequestBloc(GetIt.instance),
                                  child: const RequestHandModal(),
                                ),
                              ),
                            ),
                            label: Text(
                              translate('map.actions.ask.hand'),
                              style: ZipFonts.small.style,
                            ),
                            icon: const Icon(
                              FontAwesomeIcons.handHoldingHeart,
                              color: ZipColor.onPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(40),
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
              IconButton(
                onPressed: isAuthenticated
                    ? () => Navigator.of(context)
                        .pushReplacementNamed(Routes.profileScreen)
                    : null,
                icon: Container(
                  width: 100,
                  height: 100,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    border: Border.all(color: ZipColor.primary, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: user == null ||
                          (user!.photo.isEmpty || user!.photoFormat.isEmpty)
                      ? const Icon(
                          Icons.person_4_rounded,
                          size: 50,
                          color: ZipColor.primary,
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
              OutlinedButton(
                onPressed: () => isAuthenticated
                    ? context.read<AuthenticationBloc>().logout()
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
          const Gap(20),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                ReactWidget(
                  stream: context.read<AuthenticationBloc>().userStream,
                  builder: (final user) => Text(
                    translate(
                      'map.hello.title',
                      args: {
                        'name': user.valueOrNull != null
                            ? ', ${user.valueOrNull!.name}'
                            : '',
                      },
                    ),
                    style: ZipFonts.big.style,
                  ),
                ),
                const Gap(10),
                Flexible(
                  child: Text(
                    translate('map.hello.subtitle'),
                    style: ZipFonts.medium.style,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}
