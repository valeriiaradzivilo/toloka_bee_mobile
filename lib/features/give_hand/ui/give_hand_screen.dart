import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../common/theme/zip_color.dart';
import '../../../common/theme/zip_fonts.dart';
import '../../../common/widgets/app_number_editing_field.dart';
import '../bloc/give_hand_bloc.dart';
import '../bloc/give_hand_event.dart';
import '../bloc/give_hand_state.dart';
import 'widgets/request_tile.dart';

class GiveHandScreen extends StatelessWidget {
  const GiveHandScreen({super.key});

  @override
  Widget build(final BuildContext context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: BlocBuilder<GiveHandBloc, GiveHandState>(
              builder: (final context, final state) => switch (state) {
                GiveHandLoading() =>
                  const Center(child: CircularProgressIndicator()),
                GiveHandError() =>
                  const Center(child: Text('Error loading requests')),
                GiveHandLoaded() => _LoadedGiveHandScreen(state),
              },
            ),
          ),
        ),
      );
}

class _LoadedGiveHandScreen extends StatefulWidget {
  const _LoadedGiveHandScreen(this.state);
  final GiveHandLoaded state;

  @override
  State<_LoadedGiveHandScreen> createState() => __LoadedGiveHandScreenState();
}

class __LoadedGiveHandScreenState extends State<_LoadedGiveHandScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        child: Column(
          children: [
            Text(
              translate('give.hand.title'),
              style: ZipFonts.big.style,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            Text(
              translate('give.hand.subtitle'),
              style: ZipFonts.tiny.style.copyWith(
                color: ZipColor.inverseSurface,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 15),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                if (!widget.state.onlyRemote)
                  Wrap(
                    spacing: 5,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        '${translate('give.hand.radius')}: ',
                        style: ZipFonts.small.style,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (widget.state.radius - 1 < 1) {
                                return;
                              }

                              context.read<GiveHandBloc>().add(
                                    ChangeRadiusEvent(widget.state.radius - 1),
                                  );
                            },
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          SizedBox(
                            width: 50,
                            child: AppNumberEditingField(
                              maxValue: 1000,
                              minValue: 1,
                              controller: _controller
                                ..text = widget.state.radius.toString(),
                              onChanged: (final p0) {
                                final parsed = int.tryParse(p0);

                                if (parsed != null) {
                                  context.read<GiveHandBloc>().add(
                                        ChangeRadiusEvent(parsed),
                                      );
                                }
                              },
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (widget.state.radius + 1 > 1000) {
                                return;
                              }

                              context.read<GiveHandBloc>().add(
                                    ChangeRadiusEvent(widget.state.radius + 1),
                                  );
                            },
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                          Text(
                            'km',
                            style: ZipFonts.small.style,
                          ),
                        ],
                      ),
                    ],
                  ),
                CheckboxListTile(
                  value: widget.state.onlyRemote,
                  contentPadding: const EdgeInsets.all(0),
                  onChanged: (final value) {
                    context.read<GiveHandBloc>().add(
                          ChangeOnlyRemoteEvent(value ?? false),
                        );
                  },
                  title: Text(
                    translate('give.hand.only_remote'),
                    style: ZipFonts.small.style,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: widget.state.requests.isNotEmpty,
              replacement: Center(
                child: Text(
                  translate('give.hand.no_requests'),
                  style: ZipFonts.medium.style,
                  textAlign: TextAlign.center,
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.state.requests.length,
                itemBuilder: (final context, final index) {
                  final request = widget.state.requests[index];
                  return Stack(
                    children: [
                      RequestTile(
                        request: request,
                        distance: context
                            .read<GiveHandBloc>()
                            .distanceTo(
                              request.latitude,
                              request.longitude,
                            )
                            .toStringAsFixed(2),
                        showStatus: false,
                        maxDescriptionLines: 5,
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Visibility(
                          visible: request.isRemote,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Transform.rotate(
                              angle: 0.5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: ZipColor.onTertiaryFixed,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                child: Text(
                                  translate('give.hand.remote'),
                                  style: ZipFonts.small.style.copyWith(
                                    color: ZipColor.onTertiary,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
                separatorBuilder:
                    (final BuildContext context, final int index) =>
                        const Divider(),
              ),
            ),
          ],
        ),
      );
}
