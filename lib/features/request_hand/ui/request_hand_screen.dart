import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:intl/intl.dart';

import '../../../common/theme/toloka_fonts.dart';
import '../../../common/widgets/app_number_editing_field.dart';
import '../../../common/widgets/app_text_editing_field.dart';
import '../../../data/models/e_request_hand_type.dart';
import '../../authentication/bloc/user_bloc.dart';
import '../bloc/create_request_bloc.dart';
import '../bloc/create_request_event.dart';
import '../bloc/create_request_state.dart';

class RequestHandModal extends StatefulWidget {
  const RequestHandModal({super.key});

  @override
  State<RequestHandModal> createState() => _RequestHandModalState();

  void add(final InitCreateRequestEvent initCreateRequestEvent) {}
}

class _RequestHandModalState extends State<RequestHandModal> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  ERequestHandType? _selectedType;

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
            stream: context.read<UserBloc>().locationStream,
            builder: (final context, final snapshot) {
              if (snapshot.hasData) {
                final location = snapshot.data;
                if (location != null) {
                  if (state is LoadedCreateRequestState &&
                      (state.location.latitude != snapshot.data!.latitude ||
                          state.location.longitude !=
                              snapshot.data!.longitude)) {
                    context.read<CreateRequestBloc>().add(
                          SetLocationEvent(
                            location.latitude,
                            location.longitude,
                          ),
                        );
                  }

                  switch (state) {
                    case CreateRequestLoading():
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    case LoadedCreateRequestState(:final userHasContactInfo)
                        when !userHasContactInfo:
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            translate('request.hand.no_contact_info'),
                            style: TolokaFonts.big.error,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    case final LoadedCreateRequestState state:
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 16,
                            children: [
                              Text(
                                translate('request.hand.title'),
                                style: TolokaFonts.big.style,
                              ),
                              DropdownButtonFormField<ERequestHandType>(
                                value: _selectedType,
                                hint:
                                    Text(translate('request.hand.type.label')),
                                items: ERequestHandType.values
                                    .map(
                                      (final type) =>
                                          DropdownMenuItem<ERequestHandType>(
                                        value: type,
                                        child: Text(type.text),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (final value) {
                                  if (value == null) return;

                                  context.read<CreateRequestBloc>().add(
                                        SetRequestTypeEvent(value),
                                      );
                                },
                              ),
                              AppTextField(
                                controller: _descriptionController,
                                label: translate('request.hand.description'),
                                onChanged: (final p0) {
                                  context.read<CreateRequestBloc>().add(
                                        SetDescriptionEvent(p0),
                                      );
                                },
                                maxSymbols: 500,
                              ),
                              CheckboxListTile(
                                value: state.isRemote,
                                onChanged: (final value) {
                                  if (value == null) return;
                                  context.read<CreateRequestBloc>().add(
                                        SetIsRemoteEvent(value),
                                      );
                                },
                                title: Text(
                                  translate('request.hand.remote.title'),
                                ),
                                subtitle: Text(
                                  translate('request.hand.remote.description'),
                                ),
                              ),
                              if (!state.isRemote)
                                CheckboxListTile(
                                  value: state.isPhysicalStrength,
                                  onChanged: (final value) {
                                    if (value == null) return;
                                    context.read<CreateRequestBloc>().add(
                                          SetIsPhysicalStrengthEvent(value),
                                        );
                                  },
                                  title: Text(
                                    translate('request.hand.physical.title'),
                                  ),
                                  subtitle: Text(
                                    translate(
                                      'request.hand.physical.description',
                                    ),
                                  ),
                                ),
                              GestureDetector(
                                onTap: () async {
                                  final now = DateTime.now();
                                  final dateOfBirth = await showDatePicker(
                                    context: context,
                                    firstDate: now,
                                    lastDate:
                                        now.add(const Duration(days: 365)),
                                  );

                                  if (dateOfBirth == null) return;
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
                                  subtitle: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        '${translate('request.hand.deadline.description')}\n',
                                      ),
                                      Text(
                                        translate(
                                          'request.hand.deadline.current',
                                          args: {
                                            'date':
                                                DateFormat.yMMMMEEEEd().format(
                                              state.deadline ?? DateTime.now(),
                                            ),
                                          },
                                        ),
                                        style: TolokaFonts.small.style.copyWith(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
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
                                        translate(
                                          'request.hand.price.description',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: AppNumberEditingField(
                                      controller: _priceController,
                                      label:
                                          translate('request.hand.price.label'),
                                      minValue: 0,
                                      maxValue: 10000,
                                      onChanged: (final value) {
                                        final double? parsedValue =
                                            value.isNotEmpty
                                                ? double.tryParse(value)
                                                : 0;
                                        if (parsedValue == null) return;
                                        context.read<CreateRequestBloc>().add(
                                              SetPriceEvent(parsedValue),
                                            );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: ListTile(
                                      title: Text(
                                        translate(
                                          'request.hand.volunteers.title',
                                        ),
                                      ),
                                      subtitle: Text(
                                        translate(
                                          'request.hand.volunteers.description',
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      spacing: 2,
                                      children: [
                                        IconButton(
                                          onPressed: () {
                                            if (state.requiredVolunteersCount <
                                                2) {
                                              return;
                                            }

                                            context
                                                .read<CreateRequestBloc>()
                                                .add(
                                                  SetRequiredVolunteersCountEvent(
                                                    state.requiredVolunteersCount -
                                                        1,
                                                  ),
                                                );
                                          },
                                          icon: const Icon(
                                            Icons.remove,
                                            size: 40,
                                          ),
                                        ),
                                        Text(
                                          state.requiredVolunteersCount
                                              .toString(),
                                          style: TolokaFonts.medium.style,
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            if (state.requiredVolunteersCount >
                                                4) {
                                              return;
                                            }
                                            context
                                                .read<CreateRequestBloc>()
                                                .add(
                                                  SetRequiredVolunteersCountEvent(
                                                    state.requiredVolunteersCount +
                                                        1,
                                                  ),
                                                );
                                          },
                                          icon: const Icon(
                                            Icons.add,
                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _descriptionController
                                              .text.isNotEmpty &&
                                          (state.isRemote ||
                                              (state.location.latitude != 0 &&
                                                  state.location.longitude !=
                                                      0)) &&
                                          state.requiredVolunteersCount > 0
                                      ? () {
                                          context.read<CreateRequestBloc>().add(
                                                SendRequestEvent(context),
                                              );
                                          Navigator.of(context).pop();
                                        }
                                      : null,
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
  //TODO: Додай інформацію, що локація не передається волонтеру, тому бажано одразу вказати її в описі або місце де ви хочете з людиною зустрітись. Локація користувача чисто використовується для обмеження дистанції. Якщо ви не хочете передавати писати локацію квартири або будинку, напишіть будь-яку локацію поруч з вами, наприклад магазин або тц. Також можете вказати в описі, щоб волонтери написали вам в особисті повідомлення для того, щоб дізнатись адресу.
}
