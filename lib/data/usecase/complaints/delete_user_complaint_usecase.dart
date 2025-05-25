import 'package:dartz/dartz.dart';

import '../../repository/complaints/complaint_repository.dart';
import '../usecase.dart';

class DeleteUserComplaintUsecase extends UseCase<Either, List<String>> {
  final ComplaintRepository _complaintRepository;

  DeleteUserComplaintUsecase(
    this._complaintRepository,
  );

  @override
  Future<Either<Fail, void>> call(
    final List<String> params,
  ) async {
    for (final complaintId in params) {
      final result =
          await _complaintRepository.deleteUserComplaint(complaintId);
      if (result.isLeft()) {
        return result;
      }
    }

    return const Right(null);
  }
}
