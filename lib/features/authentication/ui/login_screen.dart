import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';

import '../../../common/reactive/react_widget.dart';
import '../bloc/authentication_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = AuthenticationBloc(GetIt.instance);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _authenticationBloc.dispose();
    super.dispose();
  }

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;
    _authenticationBloc.authenticate(username, password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('login.title')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: translate('login.username')),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: translate('login.password')),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text(translate('login.button')),
            ),
            ReactWidget(
                stream: _authenticationBloc.isAuthenticated,
                builder: (isAuthenticated) {
                  if (isAuthenticated) {
                    return Text(translate('login.success'));
                  } else {
                    return Text(translate('login.failure'));
                  }
                }),
          ],
        ),
      ),
    );
  }
}
