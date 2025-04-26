import 'package:dartz/dartz.dart';
import 'package:simple_logger/simple_logger.dart';

import '../../models/request_complaints_group_model.dart';
import '../../models/user_complaints_group_model.dart';
import '../../source/complaints/complaint_data_source.dart';
import 'complaint_repository.dart';

class ComplaintRepositoryImpl implements ComplaintRepository {
  final ComplaintDataSource _dataSource;
  ComplaintRepositoryImpl(this._dataSource);

  static final logger = SimpleLogger();

  @override
  Future<Either<Fail, List<RequestComplaintsGroupModel>>>
      getRequestComplaintsGrouped(final String adminUserId) async {
    try {
      final list = await _dataSource.getRequestComplaintsGrouped(adminUserId);
      return Right(list);
    } catch (e) {
      logger.severe('Error fetching request complaints: $e');
      return Left(Fail('Failed to load request complaints'));
    }
  }

  @override
  Future<Either<Fail, List<UserComplaintsGroupModel>>> getUserComplaintsGrouped(
    final String adminUserId,
  ) async {
    try {
      final list = await _dataSource.getUserComplaintsGrouped(adminUserId);
      return Right(list);
    } catch (e) {
      logger.severe('Error fetching user complaints: $e');
      return Left(Fail('Failed to load user complaints'));
    }
  }
}
