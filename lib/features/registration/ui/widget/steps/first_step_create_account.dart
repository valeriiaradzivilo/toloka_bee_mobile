import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../common/reactive/react_widget.dart';
import '../../../../../common/widgets/lin_text_editing_field.dart';
import '../../../bloc/register_bloc.dart';

class FirstStepCreateAccount extends StatefulWidget {
  const FirstStepCreateAccount({super.key});

  @override
  State<FirstStepCreateAccount> createState() => _FirstStepCreateAccountState();
}

class _FirstStepCreateAccountState extends State<FirstStepCreateAccount> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final registerBloc = context.read<RegisterBloc>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        LinTextField(
          initialValue: registerBloc.nameStream.value,
          controller: _nameController,
          label: translate('create.account.name'),
          option: TextFieldOption.name,
          onChanged: (final p0) => registerBloc.setName(p0),
          onValidate: (final p0) => registerBloc.onValidateFieldsOnThePage(p0),
        ),
        LinTextField(
          initialValue: registerBloc.surnameStream.value,
          controller: _surnameController,
          label: translate('create.account.surname'),
          option: TextFieldOption.name,
          onChanged: (final p0) => registerBloc.setSurname(p0),
          onValidate: (final p0) => registerBloc.onValidateFieldsOnThePage(p0),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            GestureDetector(
              onTap: () async {
                final now = DateTime.now();
                final dateOfBirth = await showDatePicker(
                  context: context,
                  firstDate: now.subtract(const Duration(days: 150 * 365)),
                  lastDate: DateTime(
                    now.year - 18,
                    now.month,
                    now.day - 1,
                  ),
                );

                if (dateOfBirth == null) {
                  return;
                }
                await registerBloc.setDateOfBirth(dateOfBirth);
              },
              child: Row(
                spacing: 20,
                children: [
                  ReactWidget(
                    stream: registerBloc.dateOfBirthStream,
                    builder: (final data) => Text(
                      data.valueOrNull == null
                          ? translate('create.account.date.of.birth')
                          : data.valueOrNull!.toString(),
                    ),
                  ),
                  const Icon(Icons.calendar_today),
                ],
              ),
            ),
            Tooltip(
              message: translate('create.account.age.limitations'),
              triggerMode: TooltipTriggerMode.tap,
              child: const Icon(
                Icons.info,
                size: 15,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
