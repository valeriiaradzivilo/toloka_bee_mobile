import 'package:dartz/dartz.dart';

import '../../models/contact_info_model.dart';
import '../../repository/contacts/contacts_repository.dart';
import '../usecase.dart';

class GetContactByUserIdUsecase extends UseCase<Either, String> {
  final ContactsRepository _contactsRepository;
  GetContactByUserIdUsecase(this._contactsRepository);
  @override
  Future<Either<Fail, ContactInfoModel?>> call(final String params) async =>
      await _contactsRepository.getContactByUserId(params);
}
