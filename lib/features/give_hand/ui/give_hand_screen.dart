import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

import '../../../common/theme/zip_color.dart';
import '../../../common/theme/zip_fonts.dart';
import '../../../common/widgets/lin_number_editing_field.dart';
import '../bloc/give_hand_bloc.dart';
import '../bloc/give_hand_event.dart';
import '../bloc/give_hand_state.dart';

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
  Widget build(final BuildContext context) => Column(
        children: [
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              if (!widget.state.onlyRemote)
                Row(
                  children: [
                    Text(
                      '${translate('give.hand.radius')}: ',
                      style: ZipFonts.medium.style,
                    ),
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
                      width: 60,
                      child: LinNumberEditingField(
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
                      style: ZipFonts.medium.style,
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
                  style: ZipFonts.medium.style,
                ),
              ),
            ],
          ),
          Expanded(
            child: Visibility(
              visible: widget.state.requests.isNotEmpty,
              replacement: Center(
                child: Text(
                  translate('give.hand.no_requests'),
                  style: ZipFonts.medium.style,
                  textAlign: TextAlign.center,
                ),
              ),
              child: ListView.separated(
                itemCount: widget.state.requests.length,
                itemBuilder: (final context, final index) {
                  final request = widget.state.requests[index];
                  return Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: Visibility(
                          visible: request.isRemote,
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
                      ListTile(
                        leading: const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://thumb.ac-illust.com/30/30fa090868a2f8236c55ef8c1361db01_t.jpeg',
                          ),
                        ),
                        title: Text(
                          request.description,
                          style: ZipFonts.medium.style,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '\u2981 ${translate(
                                  'give.hand.deadline',
                                  args: {
                                    'date': DateFormat.yMMMMEEEEd()
                                        .format(request.deadline),
                                    'days': request.deadline
                                        .difference(DateTime.now())
                                        .inDays
                                        .toString(),
                                  },
                                )}',
                              ),
                              if (request.price != null && request.price != 0)
                                Text(
                                  '\u2981 ${translate(
                                    'give.hand.price',
                                    args: {
                                      'price': request.price.toString(),
                                    },
                                  )}',
                                ),
                              if (request.isRemote == false)
                                Text(
                                  '\u2981 ${translate(
                                    'give.hand.distance',
                                    args: {
                                      'distance': context
                                          .read<GiveHandBloc>()
                                          .distanceTo(
                                            request.latitude,
                                            request.longitude,
                                          )
                                          .toStringAsFixed(2),
                                    },
                                  )}',
                                ),
                            ],
                          ),
                        ),
                        onTap: () {
                          // Navigate to request details screen
                        },
                      ),
                    ],
                  );
                },
                separatorBuilder:
                    (final BuildContext context, final int index) =>
                        const Divider(),
              ),
            ),
          ),
        ],
      );
}
