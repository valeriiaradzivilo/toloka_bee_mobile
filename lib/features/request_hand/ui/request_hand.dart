import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../common/theme/zip_fonts.dart';
import '../../../common/widgets/lin_number_editing_field.dart';
import '../../../common/widgets/lin_text_editing_field.dart';
import '../../location_controll/bloc/location_controll_bloc.dart';
import '../bloc/create_request_bloc.dart';
import '../bloc/create_request_event.dart';
import '../bloc/create_request_state.dart';

class RequestHandModal extends StatefulWidget {
  const RequestHandModal({super.key});

  @override
  State<RequestHandModal> createState() => _RequestHandModalState();
}

class _RequestHandModalState extends State<RequestHandModal> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        child: BlocBuilder<CreateRequestBloc, CreateRequestState>(
          builder: (final context, final state) => StreamBuilder(
            stream: context.read<LocationControllBloc>().locationStream,
            builder: (final context, final snapshot) {
              if (snapshot.hasData) {
                final location = snapshot.data;
                if (location != null) {
                  if (state.location.latitude != snapshot.data!.latitude ||
                      state.location.longitude != snapshot.data!.longitude) {
                    context.read<CreateRequestBloc>().add(
                          SetLocationEvent(
                            location.latitude,
                            location.longitude,
                          ),
                        );
                  }

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 16,
                        children: [
                          Text(
                            translate('request.hand.title'),
                            style: ZipFonts.medium.style,
                          ),
                          LinTextField(
                            controller: _descriptionController,
                            label: translate('request.hand.description'),
                            onChanged: (final p0) {
                              context.read<CreateRequestBloc>().add(
                                    SetDescriptionEvent(p0),
                                  );
                            },
                          ),
                          CheckboxListTile(
                            value: state.isRemote,
                            onChanged: (final value) {
                              if (value == null) {
                                return;
                              }
                              context.read<CreateRequestBloc>().add(
                                    SetIsRemoteEvent(value),
                                  );
                            },
                            title: Text(translate('request.hand.remote.title')),
                            subtitle: Text(
                              translate('request.hand.remote.description'),
                            ),
                          ),
                          if (!state.isRemote)
                            CheckboxListTile(
                              value: state.isPhysicalStrength,
                              onChanged: (final value) {
                                if (value == null) {
                                  return;
                                }
                                context.read<CreateRequestBloc>().add(
                                      SetIsPhysicalStrengthEvent(value),
                                    );
                              },
                              title: Text(
                                translate('request.hand.physical.title'),
                              ),
                              subtitle: Text(
                                translate('request.hand.physical.description'),
                              ),
                            ),
                          GestureDetector(
                            onTap: () async {
                              final now = DateTime.now();
                              final dateOfBirth = await showDatePicker(
                                context: context,
                                firstDate: now,
                                lastDate: now.add(const Duration(days: 365)),
                              );

                              if (dateOfBirth == null) {
                                return;
                              }
                              if (context.mounted) {
                                context.read<CreateRequestBloc>().add(
                                      SetDeadlineEvent(dateOfBirth),
                                    );
                              }
                            },
                            child: ListTile(
                              title: Text(
                                translate('request.hand.deadline.title'),
                              ),
                              subtitle: Text(
                                state.deadline == null
                                    ? translate(
                                        'request.hand.deadline.description',
                                      )
                                    : state.deadline.toString(),
                              ),
                              trailing: const Icon(Icons.calendar_today),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: ListTile(
                                  title: Text(
                                    translate('request.hand.price.title'),
                                  ),
                                  subtitle: Text(
                                    translate('request.hand.price.description'),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: LinNumberEditingField(
                                  controller: _priceController,
                                  label: translate('request.hand.price.label'),
                                  minValue: 0,
                                  maxValue: 10000,
                                  onChanged: (final value) {
                                    final double? parsedValue =
                                        double.tryParse(value);
                                    if (parsedValue == null) {
                                      return;
                                    }
                                    context.read<CreateRequestBloc>().add(
                                          SetPriceEvent(parsedValue),
                                        );
                                  },
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: ElevatedButton(
                              onPressed: () =>
                                  context.read<CreateRequestBloc>().add(
                                        SendRequestEvent(),
                                      ),
                              child: Text(
                                translate('request.hand.submit'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }
              return Center(
                child: CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
        ),
      );
}
