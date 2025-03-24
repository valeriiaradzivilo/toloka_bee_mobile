import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../common/theme/zip_fonts.dart';
import '../../../../../common/widgets/lin_text_editing_field.dart';
import '../../../bloc/register_bloc.dart';
import '../../data/e_position.dart';
import '../../data/e_steps.dart';
import '../next_back_button_row.dart';

class ThirdStepCreateAccount extends StatefulWidget {
  const ThirdStepCreateAccount({super.key});

  @override
  State<ThirdStepCreateAccount> createState() => _ThirdStepCreateAccountState();
}

class _ThirdStepCreateAccountState extends State<ThirdStepCreateAccount> {
  final _aboutMeController = TextEditingController();
  final _menuController = MenuController();

  EPosition? _position;

  bool _isAboutMeValid = false;

  @override
  void dispose() {
    _aboutMeController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          const Spacer(),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              translate('create.account.about.title'),
              style: ZipFonts.medium.style,
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(translate('create.account.about.subtitle')),
          ),
          LinTextField(
            controller: _aboutMeController,
            label: translate('create.account.about.title'),
            onChanged: (final p0) {
              context.read<RegisterBloc>().setAboutMe(p0);
              if (_isAboutMeValid != p0.isNotEmpty) {
                setState(() => _isAboutMeValid = p0.isNotEmpty);
              }
            },
          ),
          MenuAnchor(
            controller: _menuController,
            menuChildren: [
              for (final position in EPosition.values)
                ListTile(
                  title: Text(
                    position.text,
                  ),
                  onTap: () => setState(() {
                    _menuController.close();
                    _position = position;
                  }),
                ),
            ],
            builder: (final context, final controller, final child) => ListTile(
              title: _position == null
                  ? Text(translate('create.account.preffered.position.title'))
                  : Text(_position!.text),
              subtitle: _position == null
                  ? Text(
                      translate('create.account.preffered.position.subtitle'),
                    )
                  : null,
              trailing: const Icon(Icons.arrow_drop_down),
              onTap: () =>
                  controller.isOpen ? controller.close() : controller.open(),
            ),
          ),
          const Spacer(),
          NextBackButtonRow(
            step: ESteps.addExtraInfo,
            areFieldsValid: _isAboutMeValid,
            position: _position,
          ),
        ],
      );
}
