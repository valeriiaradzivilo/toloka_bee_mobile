import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

import '../../../common/condition_widget.dart';
import '../../../common/reactive/react_widget.dart';
import '../../../common/routes.dart';
import '../../../common/theme/zip_color.dart';
import '../../../common/theme/zip_fonts.dart';
import 'bloc/map_screen_bloc.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<MapScreenBloc>();
    return Scaffold(
      body: ReactWidget(
        stream: bloc.locationServiceEnabled,
        builder: (locationEnabled) => ConditionWidget(
          condition: locationEnabled,
          onTrue: Stack(
            children: [
              ReactWidget(
                stream: bloc.locationStream,
                builder: (data) => FlutterMap(
                  mapController: bloc.mapController,
                  options: MapOptions(
                    interactionOptions: const InteractionOptions(
                      enableMultiFingerGestureRace: false,
                      pinchMoveWinGestures: MultiFingerGesture.none,
                      pinchZoomWinGestures: MultiFingerGesture.none,
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
                        urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        tileBuilder: (context, widget, tile) => widget),
                  ],
                ),
              ),
              const Align(alignment: Alignment.bottomCenter, child: _BottomSheet()),
            ],
          ),
          onFalse: Center(
              child: Text(
            translate('location.disabled'),
            style: ZipFonts.big.error,
          )),
        ),
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.3,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: ZipColor.surfaceBright,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Flexible(child: _AccountInfo()),
          const Divider(),
          const Gap(10),
          Text(
            translate('map.actions.question'),
            style: ZipFonts.medium.style,
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
                  icon: const Icon(Icons.handshake_outlined),
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
                  icon: const Icon(FontAwesomeIcons.handHoldingHeart),
                ),
              ),
            ],
          ),
          const Gap(40),
        ],
      ),
    );
  }
}

class _AccountInfo extends StatelessWidget {
  const _AccountInfo();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () => Navigator.of(context).pushNamed(Routes.profileScreen),
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
                onPressed: () => Navigator.of(context).pushNamed(Routes.loginScreen),
                child: Text(translate('map.actions.logout'))),
          ],
        ),
        const Gap(20),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                translate('map.hello.title', args: {'name': 'John'}),
                style: ZipFonts.big.style,
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
}
