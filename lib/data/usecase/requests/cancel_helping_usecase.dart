import 'package:dartz/dartz.dart';

import '../../repository/volunteer_work/volunteer_work_repository.dart';
import '../usecase.dart';

class CancelHelpingUsecase extends UseCase<Either, String> {
  final VolunteerWorkRepository _volunteerWorkRepository;

  CancelHelpingUsecase(this._volunteerWorkRepository);

  @override
  Future<Either<Fail, void>> call(
    final String params,
  ) async =>
      await _volunteerWorkRepository.cancelHelping(params);
}
