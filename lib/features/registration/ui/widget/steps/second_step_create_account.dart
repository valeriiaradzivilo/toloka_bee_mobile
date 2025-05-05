import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../common/reactive/react_widget.dart';
import '../../../../../common/theme/zip_fonts.dart';
import '../../../../../common/widgets/lin_text_editing_field.dart';
import '../../../bloc/register_bloc.dart';
import '../../data/e_steps.dart';
import '../next_back_button_row.dart';

class SecondStepCreateAccount extends StatefulWidget {
  const SecondStepCreateAccount({super.key});

  @override
  State<SecondStepCreateAccount> createState() =>
      _SecondStepCreateAccountState();
}

class _SecondStepCreateAccountState extends State<SecondStepCreateAccount> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isEmailValid = true;
  bool _isPasswordValid = false;
  bool _isConfirmPasswordValid = false;
  bool _termsAccepted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final registerBloc = context.read<RegisterBloc>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        const Spacer(),
        ReactWidget(
          stream: registerBloc.emailStream,
          builder: (final email) => LinTextField(
            controller: _emailController..text = email,
            label: translate('create.account.email'),
            option: TextFieldOption.email,
            onChanged: (final p0) => registerBloc.email = p0,
            onValidate: (final p0) => setState(() {
              _isEmailValid = p0;
            }),
          ),
        ),
        LinTextField(
          controller: _passwordController,
          label: translate('create.account.password'),
          option: TextFieldOption.password,
          onChanged: (final p0) => registerBloc.password = p0,
          onValidate: (final p0) => setState(() {
            _isPasswordValid = p0;
          }),
        ),
        LinTextField(
          controller: _confirmPasswordController,
          label: translate('create.account.confirm.password'),
          option: TextFieldOption.password,
          textToMatch: _passwordController.text,
          onValidate: (final p0) => setState(() {
            _isConfirmPasswordValid = p0;
          }),
        ),
        CheckboxListTile(
          value: _termsAccepted,
          onChanged: (final value) {
            setState(() => _termsAccepted = value ?? false);
          },
          title: Row(
            children: [
              Text(translate('create.account.terms.accept')),
              const SizedBox(width: 5),
              GestureDetector(
                onTap: () => showDialog(
                  context: context,
                  builder: (final _) => AlertDialog(
                    title: Text(translate('create.account.terms.title')),
                    content: SingleChildScrollView(
                      child: Text(translate('create.account.terms.content')),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(translate('common.ok')),
                      ),
                    ],
                  ),
                ),
                child: Text(
                  translate('create.account.terms.read'),
                  style: ZipFonts.medium.style.copyWith(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        Flexible(
          child: NextBackButtonRow(
            step: ESteps.addRegisterInfo,
            areFieldsValid: _isEmailValid &&
                _isPasswordValid &&
                _isConfirmPasswordValid &&
                _confirmPasswordController.text.isNotEmpty &&
                _passwordController.text.isNotEmpty &&
                _emailController.text.isNotEmpty &&
                _termsAccepted,
          ),
        ),
      ],
    );
  }
}
