import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

import '../../../common/bloc/zip_bloc.dart';
import '../../../common/optional_value.dart';
import '../../../data/models/user_auth_model.dart';
import '../../../data/usecase/register_user_usecase.dart';
import '../ui/data/e_position.dart';
import '../ui/data/e_steps.dart';

class RegisterBloc extends ZipBloc {
  RegisterBloc(final GetIt serviceLocator)
      : _registerUserUsecase = serviceLocator<RegisterUserUsecase>();

  ValueStream<ESteps> get stepCounterStream => _stepController.stream;

  ValueStream<Optional<DateTime>> get dateOfBirthStream =>
      _dateOfBirthController.stream;
  ValueStream<String> get nameStream => _nameController.stream;
  ValueStream<String> get surnameStream => _surnameController.stream;

  ValueStream<String> get emailStream => _emailController.stream;

  Future<bool> register(final EPosition position) async {
    final isRegistered = await _registerUserUsecase(
      UserAuthModel(
        email: _emailController.value,
        password: _passwordController.value,
        username: _usernameController.value,
        name: _nameController.value,
        surname: _surnameController.value,
        birthDate: _dateOfBirthController.value.valueOrNull!.toIso8601String(),
        position: position.name.toLowerCase(),
        about: _aboutMeController.value,
        photoId: '',
      ),
    );
    logger.info('User registered: ${isRegistered.isRight()}');
    return isRegistered.isRight();
  }

  void setName(final String name) {
    _nameController.add(name);
  }

  void setSurname(final String surname) {
    _surnameController.add(surname);
  }

  void setUsername(final String username) {
    _usernameController.add(username);
  }

  void setPassword(final String password) {
    _passwordController.add(password);
  }

  void setEmail(final String email) {
    _emailController.add(email);
  }

  void setDateOfBirth(final DateTime dateOfBirth) {
    _dateOfBirthController.add(OptionalValue(dateOfBirth));
  }

  void nextStep() {
    if (_stepController.value.nextStep == null) return;

    _stepController.add(_stepController.value.nextStep!);
  }

  void previousStep() {
    if (_stepController.value.previousStep == null) return;

    _stepController.add(_stepController.value.previousStep!);
  }

  void setAboutMe(final String aboutMe) {
    _aboutMeController.add(aboutMe);
  }

  @override
  Future<void> dispose() async {
    await _nameController.close();
    await _surnameController.close();
    await _usernameController.close();
    await _passwordController.close();
    await _emailController.close();
    await _dateOfBirthController.close();
    await _stepController.close();
    await _aboutMeController.close();

    await super.dispose();
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

  final BehaviorSubject<String> _emailController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<Optional<DateTime>> _dateOfBirthController =
      BehaviorSubject<Optional<DateTime>>.seeded(
    const OptionalNull<DateTime>(),
  );

  final BehaviorSubject<String> _aboutMeController =
      BehaviorSubject<String>.seeded('');

  final BehaviorSubject<ESteps> _stepController =
      BehaviorSubject<ESteps>.seeded(ESteps.checkGeneralInfo);
}
