import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../common/widgets/lin_text_editing_field.dart';
import '../../../bloc/register_bloc.dart';

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

  @override
  Widget build(final BuildContext context) {
    final registerBloc = context.read<RegisterBloc>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 20,
      children: [
        LinTextField(
          controller: _emailController,
          label: translate('create.account.email'),
          option: TextFieldOption.email,
          onChanged: (final p0) => registerBloc.setEmail(p0),
          onValidate: (final p0) => registerBloc.onValidateFieldsOnThePage(p0),
        ),
        LinTextField(
          controller: _passwordController,
          label: translate('create.account.password'),
          option: TextFieldOption.password,
          onChanged: (final p0) => registerBloc.setPassword(p0),
          onValidate: (final p0) => registerBloc.onValidateFieldsOnThePage(p0),
        ),
        LinTextField(
          controller: _confirmPasswordController,
          label: translate('create.account.confirm.password'),
          option: TextFieldOption.password,
          textToMatch: _passwordController.text,
          onValidate: (final p0) => registerBloc.onValidateFieldsOnThePage(p0),
        ),
      ],
    );
  }
}
