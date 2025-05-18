import 'package:dartz/dartz.dart';

import '../../repository/complaints/complaint_repository.dart';
import '../usecase.dart';

class BlockUserUsecase extends UseCase<Either, BlockUserUsecaseParams> {
  final ComplaintRepository _repository;

  BlockUserUsecase(this._repository);

  @override
  Future<Either<Fail, void>> call(
    final BlockUserUsecaseParams params,
  ) =>
      _repository.blockUser(
        params.userId,
        params.blockUntil,
      );
}

class BlockUserUsecaseParams {
  final String userId;
  final DateTime blockUntil;

  BlockUserUsecaseParams({
    required this.userId,
    required this.blockUntil,
  });
}
