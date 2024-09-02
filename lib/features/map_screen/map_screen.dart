import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:zip_way/common/condition_widget.dart';
import 'package:zip_way/common/reactive/react_widget.dart';
import 'package:zip_way/common/theme/zip_fonts.dart';
import 'package:zip_way/features/map_screen/bloc/map_screen_bloc.dart';

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
          onTrue: ReactWidget(
              stream: bloc.locationStream,
              builder: (data) => FlutterMap(
                    mapController: bloc.mapController,
                    options: MapOptions(
                      interactionOptions: const InteractionOptions(
                        enableMultiFingerGestureRace: true,
                        pinchMoveWinGestures: MultiFingerGesture.pinchMove,
                      ),
                      onMapReady: () => bloc.onMapCreated(data),
                      initialZoom: 14,
                      maxZoom: 14,
                      minZoom: 1,
                      keepAlive: true,
                      initialCenter: LatLng(data.latitude, data.longitude),
                    ),
                    children: [
                      TileLayer(
                          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          tileBuilder: (context, widget, tile) => widget),
                    ],
                  )),
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
