import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../common/reactive/react_widget.dart';
import '../../../common/routes.dart';
import '../../../common/theme/zip_color.dart';
import '../../../common/theme/zip_fonts.dart';
import '../../authentication/bloc/authentication_bloc.dart';
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
                ReactWidget(
                  stream: bloc.locationStream,
                  builder: (final data) => FlutterMap(
                    mapController: bloc.mapController,
                    options: MapOptions(
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.none,
                        pinchMoveWinGestures: MultiFingerGesture.none,
                        pinchZoomWinGestures: MultiFingerGesture.none,
                      ),
                      onMapReady: () => bloc.onMapCreated(data),
                      initialZoom: 10,
                      maxZoom: 10,
                      minZoom: 1,
                      keepAlive: true,
                      initialCenter: LatLng(data.latitude, data.longitude),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        tileBuilder:
                            (final context, final widget, final tile) => widget,
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
        stream: context.read<AuthenticationBloc>().isAuthenticated,
        builder: (final isAuthenticated) => Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: ZipColor.surfaceBright,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(child: _AccountInfo(isAuthenticated)),
              Visibility(
                visible: isAuthenticated,
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
                            onPressed: () {},
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
                            onPressed: () {},
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
  const _AccountInfo(this.isAuthenticated);
  final bool isAuthenticated;

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
                  decoration: BoxDecoration(
                    border: Border.all(color: ZipColor.primary, width: 2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person_4_rounded,
                    size: 50,
                    color: ZipColor.primary,
                  ),
                ),
              ),
              OutlinedButton(
                onPressed: () => Navigator.of(context)
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
