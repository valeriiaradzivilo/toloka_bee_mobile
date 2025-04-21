import 'package:dartz/dartz.dart';
import 'package:simple_logger/simple_logger.dart';

import '../../models/contact_info_model.dart';
import '../../source/contacts/contacts_data_source.dart';
import 'contacts_repository.dart';

class ContactsRepositoryImpl implements ContactsRepository {
  final ContactsDataSource _dataSource;
  final logger = SimpleLogger();

  ContactsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Fail, ContactInfoModel>> saveContact(
    final ContactInfoModel info,
  ) async {
    try {
      return Right(await _dataSource.saveContact(info));
    } catch (e) {
      logger.severe('saveContact error: $e');
      return Left(Fail('Failed to save contact'));
    }
  }

  @override
  Future<Either<Fail, void>> updateContact(final ContactInfoModel info) async {
    try {
      return Right(await _dataSource.updateContact(info));
    } catch (e) {
      logger.severe('updateContact error: $e');
      return Left(Fail('Failed to update contact'));
    }
  }

  @override
  Future<Either<Fail, ContactInfoModel>> getContactById(final String id) async {
    try {
      return Right(await _dataSource.getContactById(id));
    } catch (e) {
      logger.severe('getContactById error: $e');
      return Left(Fail('Failed to fetch contact by id'));
    }
  }

  @override
  Future<Either<Fail, ContactInfoModel?>> getContactByUserId(
    final String userId,
  ) async {
    try {
      return Right(await _dataSource.getContactByUserId(userId));
    } catch (e) {
      logger.severe('getContactByUserId error: $e');
      return Left(Fail('Failed to fetch contact by userId'));
    }
  }

  @override
  Future<Either<Fail, void>> deleteContactById(final String id) async {
    try {
      await _dataSource.deleteContactById(id);
      return const Right(null);
    } catch (e) {
      logger.severe('deleteContactById error: $e');
      return Left(Fail('Failed to delete contact'));
    }
  }
}
