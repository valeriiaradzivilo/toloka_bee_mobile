import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';

import '../../../common/widgets/lin_text_editing_field.dart';
import '../../../data/models/user_model.dart';
import '../bloc/register_bloc.dart';

class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => RegisterBloc(GetIt.I),
      builder: (context, child) => const _CreateAccountScreen(),
    );
  }
}

class _CreateAccountScreen extends StatefulWidget {
  const _CreateAccountScreen();

  @override
  State<_CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<_CreateAccountScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();

  late final RegisterBloc _registerBloc;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _surnameController.dispose();
    super.dispose();
  }

  void _createAccount() {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final email = _emailController.text;
    final name = _nameController.text;
    final surname = _surnameController.text;

    if (password != confirmPassword) {
      return;
    }

    _registerBloc.register(UserModel(
      id: '',
      username: username,
      password: password,
      email: email,
      name: name,
      surname: surname,
    ));
  }

  @override
  Widget build(BuildContext context) {
    _registerBloc = context.read<RegisterBloc>();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LinTextField(
              controller: _emailController,
              label: translate('create.account.email'),
              option: TextFieldOption.email,
            ),
            LinTextField(
              controller: _usernameController,
              label: translate('create.account.username'),
            ),
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
            LinTextField(
              controller: _passwordController,
              label: translate('create.account.password'),
              option: TextFieldOption.password,
            ),
            LinTextField(
              controller: _confirmPasswordController,
              label: translate('create.account.confirm.password'),
              option: TextFieldOption.password,
              textToMatch: _passwordController.text,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _createAccount,
              child: Text(translate('create.account.button')),
            ),
            const Gap(20),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              child: Text(translate('create.account.cancel')),
            ),
          ],
        ),
      ),
    );
  }
}
