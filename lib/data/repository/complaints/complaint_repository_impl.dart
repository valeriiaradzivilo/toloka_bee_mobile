import 'package:dartz/dartz.dart';
import 'package:simple_logger/simple_logger.dart';

import '../../models/request_complaint_model.dart';
import '../../models/request_complaints_group_model.dart';
import '../../models/user_complaint_model.dart';
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

  @override
  Future<Either<Fail, void>> reportRequest(
    final RequestComplaintModel requestComplaintModel,
  ) async {
    try {
      await _dataSource.reportRequest(
        requestComplaintModel,
      );
      return const Right(null);
    } catch (e) {
      logger.severe('Error reporting request: $e');
      return Left(Fail('Failed to report request'));
    }
  }

  @override
  Future<Either<Fail, void>> reportUser(
    final UserComplaintModel userComplaintModel,
  ) async {
    try {
      await _dataSource.reportUser(
        userComplaintModel,
      );
      return const Right(null);
    } catch (e) {
      logger.severe('Error reporting user: $e');
      return Left(Fail('Failed to report user'));
    }
  }

  @override
  Future<Either<Fail, void>> deleteRequestComplaint(
    final String complaintId,
  ) async {
    try {
      await _dataSource.deleteRequestComplaint(complaintId);
      return const Right(null);
    } catch (e) {
      logger.severe('Error deleting complaint: $e');
      return Left(Fail('Failed to delete complaint'));
    }
  }

  @override
  Future<Either<Fail, void>> blockUser(
    final String userId,
    final DateTime blockUntil,
  ) async {
    try {
      await _dataSource.blockUser(userId, blockUntil);
      return const Right(null);
    } catch (e) {
      logger.severe('Error blocking user: $e');
      return Left(Fail('Failed to block user'));
    }
  }

  @override
  Future<Either<Fail, void>> blockUserForever(
    final String userId,
  ) async {
    try {
      await _dataSource.blockUserForever(userId);
      return const Right(null);
    } catch (e) {
      logger.severe('Error blocking user forever: $e');
      return Left(Fail('Failed to block user forever'));
    }
  }

  @override
  Future<Either<Fail, void>> deleteUserComplaint(
    final String complaintId,
  ) async {
    try {
      await _dataSource.deleteUserComplaint(complaintId);
      return const Right(null);
    } catch (e) {
      logger.severe('Error deleting user complaint: $e');
      return Left(Fail('Failed to delete user complaint'));
    }
  }
}
