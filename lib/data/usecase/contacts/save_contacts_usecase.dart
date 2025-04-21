import 'package:dartz/dartz.dart';

import '../../models/contact_info_model.dart';
import '../../repository/contacts/contacts_repository.dart';
import '../usecase.dart';

class SaveContactUsecase extends UseCase<Either, ContactInfoModel> {
  final ContactsRepository _contactsRepository;
  SaveContactUsecase(this._contactsRepository);
  @override
  Future<Either<Fail, ContactInfoModel>> call(
    final ContactInfoModel params,
  ) async =>
      await _contactsRepository.saveContact(params);
}
