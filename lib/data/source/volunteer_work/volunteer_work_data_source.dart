import '../../models/volunteer_work_model.dart';

abstract interface class VolunteerWorkDataSource {
  Future<void> startWork(
    final String volunteerId,
    final String requesterId,
    final String requestId,
  );
  Future<void> confirmByVolunteer(final String workId);
  Future<void> confirmByRequester(
    final String workId,
    final String requestId,
  );
  Future<List<VolunteerWorkModel>> getWorksByVolunteer(
    final String volunteerId,
  );
  Future<List<VolunteerWorkModel>> getWorksByRequester(
    final String requesterId,
  );
  Future<List<VolunteerWorkModel>> getWorksByRequestId(
    final String requestId,
  );
  Future<void> cancelHelping(final String id);
  Future<VolunteerWorkModel> getWorkById(final String id);
}
