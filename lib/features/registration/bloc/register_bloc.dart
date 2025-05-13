import 'dart:convert';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../../common/bloc/toloka_bloc.dart';
import '../../../common/optional_value.dart';
import '../../../data/models/contact_info_model.dart';
import '../../../data/models/user_auth_model.dart';
import '../../../data/usecase/contacts/save_contacts_usecase.dart';
import '../../../data/usecase/user_management/register_user_usecase.dart';
import '../ui/data/e_position.dart';
import '../ui/data/e_steps.dart';

class RegisterBloc extends TolokaBloc {
  RegisterBloc(final GetIt sl)
      : _registerUserUsecase = sl<RegisterUserUsecase>(),
        _saveContactUsecase = sl<SaveContactUsecase>();

  ValueStream<ESteps> get stepCounterStream => _stepController.stream;
  ValueStream<Optional<DateTime>> get dateOfBirthStream =>
      _dateOfBirthController.stream;
  ValueStream<String> get nameStream => _nameController.stream;
  ValueStream<String> get surnameStream => _surnameController.stream;
  ValueStream<String> get passwordStream => _passwordController.stream;
  ValueStream<String> get emailStream => _emailController.stream;
  ValueStream<({Uint8List bytes, String contentType})> get photoStream =>
      _photoController.stream;
  ValueStream<String> get aboutMeStream => _aboutMeController.stream;

  ValueStream<ContactMethod?> get preferredMethodStream =>
      _preferredMethodController.stream;
  ValueStream<String> get phoneStream => _phoneController.stream;
  ValueStream<String> get emailContactStream => _emailContactController.stream;
  ValueStream<String> get viberStream => _viberController.stream;
  ValueStream<String> get telegramStream => _telegramController.stream;
  ValueStream<String> get whatsAppStream => _whatsAppController.stream;

  set name(final String value) => _nameController.add(value);
  set surname(final String value) => _surnameController.add(value);

  set password(final String value) => _passwordController.add(value);
  set email(final String value) => _emailController.add(value);
  set dateOfBirth(final DateTime value) =>
      _dateOfBirthController.add(OptionalValue(value));
  set aboutMe(final String value) => _aboutMeController.add(value);
  set position(final EPosition? value) => _position = value;
  set preferredContactMethod(final ContactMethod value) =>
      _preferredMethodController.add(value);
  set contactPhone(final String value) => _phoneController.add(value);
  set contactEmail(final String value) => _emailContactController.add(value);
  set contactViber(final String value) => _viberController.add(value);
  set contactTelegram(final String value) => _telegramController.add(value);
  set contactWhatsApp(final String value) => _whatsAppController.add(value);

  EPosition? get currentPosition => _position;

  Future<bool> register() async {
    final base64Image = base64Encode(_photoController.value.bytes);
    final user = UserAuthModel(
      id: const Uuid().v4(),
      email: _emailController.value,
      password: _passwordController.value,
      name: _nameController.value,
      surname: _surnameController.value,
      birthDate: _dateOfBirthController.value.valueOrNull!.toIso8601String(),
      position: currentPosition!.name.toLowerCase(),
      about: _aboutMeController.value,
      photo: base64Image,
      photoFormat: _photoController.value.contentType,
    );
    final result = await _registerUserUsecase(user);

    await result.fold((final _) async {}, (final registeredUser) async {
      final contact = ContactInfoModel(
        id: const Uuid().v4(),
        userId: registeredUser,
        preferredMethod: _preferredMethodController.value!,
        phone: _phoneController.value.isEmpty ? null : _phoneController.value,
        email: _emailContactController.value.isEmpty
            ? null
            : _emailContactController.value,
        viber: _viberController.value.isEmpty ? null : _viberController.value,
        telegram: _telegramController.value.isEmpty
            ? null
            : _telegramController.value,
        whatsapp: _whatsAppController.value.isEmpty
            ? null
            : _whatsAppController.value,
      );
      await _saveContactUsecase(contact);
    });

    return result.isRight();
  }

  void pickImage() async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      _photoController.add((bytes: Uint8List(0), contentType: ''));
      return;
    }
    final bytes = await image.readAsBytes();
    final contentType = lookupMimeType(image.name) ?? '';
    _photoController.add((bytes: bytes, contentType: contentType));
  }

  void nextStep() {
    final next = _stepController.value.nextStep;
    if (next != null) _stepController.add(next);
  }

  void previousStep() {
    final prev = _stepController.value.previousStep;
    if (prev != null) _stepController.add(prev);
  }

  @override
  Future<void> dispose() async {
    await _nameController.close();
    await _surnameController.close();

    await _passwordController.close();
    await _emailController.close();
    await _dateOfBirthController.close();
    await _photoController.close();
    await _aboutMeController.close();
    await _stepController.close();
    await _preferredMethodController.close();
    await _phoneController.close();
    await _emailContactController.close();
    await _viberController.close();
    await _telegramController.close();
    await _whatsAppController.close();
    await super.dispose();
  }

  final RegisterUserUsecase _registerUserUsecase;
  final SaveContactUsecase _saveContactUsecase;

  final BehaviorSubject<String> _nameController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<String> _surnameController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<String> _passwordController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<String> _emailController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<Optional<DateTime>> _dateOfBirthController =
      BehaviorSubject<Optional<DateTime>>.seeded(const OptionalNull());
  final BehaviorSubject<({Uint8List bytes, String contentType})>
      _photoController =
      BehaviorSubject<({Uint8List bytes, String contentType})>.seeded(
    (bytes: Uint8List(0), contentType: ''),
  );
  final BehaviorSubject<String> _aboutMeController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<ESteps> _stepController =
      BehaviorSubject<ESteps>.seeded(ESteps.checkGeneralInfo);

  final BehaviorSubject<ContactMethod?> _preferredMethodController =
      BehaviorSubject<ContactMethod?>.seeded(null);
  final BehaviorSubject<String> _phoneController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<String> _emailContactController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<String> _viberController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<String> _telegramController =
      BehaviorSubject<String>.seeded('');
  final BehaviorSubject<String> _whatsAppController =
      BehaviorSubject<String>.seeded('');

  EPosition? _position;
}
