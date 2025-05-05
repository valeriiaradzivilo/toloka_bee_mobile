import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../common/reactive/react_widget.dart';
import '../../../../../common/theme/zip_fonts.dart';
import '../../../../../common/widgets/app_text_editing_field.dart';
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
  void initState() {
    _isAboutMeValid =
        context.read<RegisterBloc>().aboutMeStream.value.isNotEmpty;
    _position = context.read<RegisterBloc>().currentPosition;
    super.initState();
  }

  @override
  void dispose() {
    _aboutMeController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) => SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Text(
                translate('create.account.about.title'),
                style: ZipFonts.medium.style,
              ),
              Text(translate('create.account.about.subtitle')),
              ReactWidget(
                stream: context.read<RegisterBloc>().aboutMeStream,
                builder: (final about) => AppTextField(
                  controller: _aboutMeController..text = about,
                  label: translate('create.account.about.title'),
                  onChanged: (final p0) {
                    context.read<RegisterBloc>().aboutMe = p0;
                    if (_isAboutMeValid != p0.isNotEmpty) {
                      setState(() => _isAboutMeValid = p0.isNotEmpty);
                    }
                  },
                  maxSymbols: 250,
                ),
              ),
              Flexible(
                child: Row(
                  children: [
                    Expanded(
                      child: MenuAnchor(
                        controller: _menuController,
                        menuChildren: [
                          for (final position in EPosition.values)
                            ListTile(
                              title: Text(
                                position.textWantToBe,
                              ),
                              onTap: () => setState(() {
                                _menuController.close();
                                context.read<RegisterBloc>().position =
                                    position;
                                _position = position;
                              }),
                            ),
                        ],
                        builder:
                            (final context, final controller, final child) =>
                                ListTile(
                          title: _position == null
                              ? Text(
                                  translate(
                                    'create.account.preferred.position.title',
                                  ),
                                )
                              : Text(_position!.textWantToBe),
                          subtitle: _position == null
                              ? Text(
                                  translate(
                                    'create.account.preferred.position.subtitle',
                                  ),
                                )
                              : null,
                          trailing: const Icon(Icons.arrow_drop_down),
                          onTap: () => controller.isOpen
                              ? controller.close()
                              : controller.open(),
                        ),
                      ),
                    ),
                    Tooltip(
                      message: translate(
                        'create.account.preferred.position.tooltip',
                      ),
                      triggerMode: TooltipTriggerMode.tap,
                      showDuration: const Duration(seconds: 5),
                      child: const Icon(
                        Icons.info_outline,
                        size: 30,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              NextBackButtonRow(
                step: ESteps.addExtraInfo,
                areFieldsValid: _isAboutMeValid && _position != null,
              ),
            ],
          ),
        ),
      );
}
