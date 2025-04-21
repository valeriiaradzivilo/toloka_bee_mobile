import 'package:dartz/dartz.dart';

import '../../repository/contacts/contacts_repository.dart';
import '../usecase.dart';

class DeleteContactByIdUsecase extends UseCase<Either, String> {
  final ContactsRepository _contactsRepository;
  DeleteContactByIdUsecase(this._contactsRepository);
  @override
  Future<Either<Fail, void>> call(final String params) async =>
      await _contactsRepository.deleteContactById(params);
}
