import 'package:get_it/get_it.dart';
import 'package:rxdart/streams.dart';
import 'package:rxdart/subjects.dart';

import '../../../common/bloc/zip_bloc.dart';
import '../../../data/models/user_auth_model.dart';
import '../../../data/usecase/register_user_usecase.dart';
import '../ui/data/e_steps.dart';

class RegisterBloc extends ZipBloc {
  RegisterBloc(final GetIt serviceLocator)
      : _registerUserUsecase = serviceLocator<RegisterUserUsecase>();

  ValueStream<ESteps> get stepCounterStream => _stepController.stream;

  Future<void> register() async {
    final isRegistered = await _registerUserUsecase(
      UserAuthModel(
        email: _emailController.value,
        password: _passwordController.value,
        username: _usernameController.value,
        name: _nameController.value,
        surname: _surnameController.value,
        birthDate: _dateOfBirthController.value,
      ),
    );
    logger.info('User registered: ${isRegistered.isRight()}');
  }

  Future<void> setName(final String name) async {
    _nameController.add(name);
  }

  Future<void> setSurname(final String surname) async {
    _surnameController.add(surname);
  }

  Future<void> setUsername(final String username) async {
    _usernameController.add(username);
  }

  Future<void> setPassword(final String password) async {
    _passwordController.add(password);
  }

  Future<void> setConfirmPassword(final String confirmPassword) async {
    _confirmPasswordController.add(confirmPassword);
  }

  Future<void> setEmail(final String email) async {
    _emailController.add(email);
  }

  Future<void> setDateOfBirth(final DateTime dateOfBirth) async {
    _dateOfBirthController.add(dateOfBirth);
  }

  Future<void> nextStep() async {
    if (_stepController.value.nextStep == null) return;

    _stepController.add(_stepController.value.nextStep!);
  }

  Future<void> previousStep() async {
    if (_stepController.value.previousStep == null) return;

    _stepController.add(_stepController.value.previousStep!);
  }

  bool validateNextStep() {
    switch (_stepController.value) {
      case ESteps.checkGeneralInfo:
        return _nameController.value.isNotEmpty &&
            _surnameController.value.isNotEmpty &&
            _dateOfBirthController.valueOrNull != null;

      case ESteps.addRegistartInfo:
        return true;
      case ESteps.addExtraInfo:
        return true;
    }
  }

  @override
  Future<void> dispose() async {
    await _nameController.close();
    await _surnameController.close();
    await _usernameController.close();
    await _passwordController.close();
    await _confirmPasswordController.close();
    await _emailController.close();
    await _dateOfBirthController.close();
    await _stepController.close();
  }

  final RegisterUserUsecase _registerUserUsecase;

  final BehaviorSubject<String> _nameController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<String> _surnameController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<String> _usernameController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<String> _passwordController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<String> _confirmPasswordController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<String> _emailController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<DateTime> _dateOfBirthController =
      BehaviorSubject<DateTime>();

  final BehaviorSubject<ESteps> _stepController =
      BehaviorSubject<ESteps>.seeded(ESteps.checkGeneralInfo);
}
