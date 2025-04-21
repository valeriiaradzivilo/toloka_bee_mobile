import 'package:dartz/dartz.dart';

import '../../models/contact_info_model.dart';
import '../../repository/contacts/contacts_repository.dart';
import '../usecase.dart';

class UpdateContactUsecase extends UseCase<Either, ContactInfoModel> {
  final ContactsRepository _contactsRepository;
  UpdateContactUsecase(this._contactsRepository);
  @override
  Future<Either<Fail, void>> call(final ContactInfoModel params) async =>
      await _contactsRepository.updateContact(params);
}
