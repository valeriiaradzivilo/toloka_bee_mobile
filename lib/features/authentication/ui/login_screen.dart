import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';

import '../../../common/routing/routes.dart';
import '../../../common/theme/toloka_fonts.dart';
import '../bloc/user_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(final BuildContext context) => const _LoginScreen();
}

class _LoginScreen extends StatefulWidget {
  const _LoginScreen();

  @override
  State<_LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<_LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final UserBloc _authenticationBloc;

  bool loggingInProgress = false;

  @override
  void initState() {
    _authenticationBloc = context.read<UserBloc>();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _login() {
    setState(() => loggingInProgress = true);

    final email = _emailController.text;
    final password = _passwordController.text;
    _authenticationBloc.login(email, password).then(
      (final value) {
        setState(() => loggingInProgress = false);

        if (context.mounted && value && mounted) {
          Navigator.of(context).pushReplacementNamed(
            Routes.mainScreen,
          );
        }
      },
    );
  }

  @override
  Widget build(final BuildContext context) => SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: translate('login.email'),
                  ),
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: translate('login.password'),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: loggingInProgress ? null : _login,
                  child: loggingInProgress
                      ? Container(
                          width: 100,
                          margin: const EdgeInsets.all(8),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : Text(translate('login.button')),
                ),
                const Gap(20),
                Text(
                  translate('login.or'),
                  style: TolokaFonts.medium.style,
                ),
                const Gap(20),
                ElevatedButton(
                  onPressed: () => Navigator.pushReplacementNamed(
                    context,
                    Routes.createAccountScreen,
                  ),
                  child: Text(translate('login.register')),
                ),
              ],
            ),
          ),
        ),
      );
}
