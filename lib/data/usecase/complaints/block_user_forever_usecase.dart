import 'package:dartz/dartz.dart';

import '../../repository/complaints/complaint_repository.dart';
import '../usecase.dart';

class BlockUserForeverUsecase extends UseCase<Either, String> {
  final ComplaintRepository _repository;

  BlockUserForeverUsecase(this._repository);

  @override
  Future<Either<Fail, void>> call(
    final String params,
  ) =>
      _repository.blockUserForever(
        params,
      );
}
