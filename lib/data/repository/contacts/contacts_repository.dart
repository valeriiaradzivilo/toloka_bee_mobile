import 'package:dartz/dartz.dart';

import '../../models/contact_info_model.dart';

abstract class ContactsRepository {
  Future<Either<Fail, ContactInfoModel>> saveContact(
    final ContactInfoModel info,
  );
  Future<Either<Fail, void>> updateContact(final ContactInfoModel info);
  Future<Either<Fail, ContactInfoModel>> getContactById(final String id);
  Future<Either<Fail, ContactInfoModel?>> getContactByUserId(
    final String userId,
  );
  Future<Either<Fail, void>> deleteContactById(final String id);
}
