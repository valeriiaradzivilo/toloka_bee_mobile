import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';

import '../../../../../common/widgets/lin_text_editing_field.dart';

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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        LinTextField(
          controller: _nameController,
          label: translate('create.account.name'),
          option: TextFieldOption.name,
        ),
        LinTextField(
          controller: _surnameController,
          label: translate('create.account.surname'),
          option: TextFieldOption.name,
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 20,
          children: [
            GestureDetector(
              onTap: () {
                final now = DateTime.now();
                showDatePicker(
                  context: context,
                  firstDate: now.subtract(const Duration(days: 150 * 365)),
                  lastDate: DateTime(
                    now.year - 18,
                    now.month,
                    now.day - 1,
                  ),
                );
              },
              child: Row(
                spacing: 20,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(translate('create.account.date.of.birth')),
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
