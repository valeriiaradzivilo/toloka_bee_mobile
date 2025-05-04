import 'package:dio/dio.dart';

import '../../models/volunteer_work_model.dart';
import 'volunteer_work_data_source.dart';

class VolunteerWorkDataSourceImpl implements VolunteerWorkDataSource {
  final Dio _dio;

  VolunteerWorkDataSourceImpl(this._dio);

  static const _basePath = '/volunteer-work';

  @override
  Future<void> startWork(
    final String volunteerId,
    final String requesterId,
    final String requestId,
  ) async {
    await _dio.post(
      '$_basePath/start',
      data: {
        'volunteerId': volunteerId,
        'requesterId': requesterId,
        'requestId': requestId,
      },
    );
  }

  @override
  Future<void> confirmByVolunteer(final String workId) async {
    await _dio.post(
      '$_basePath/confirm/volunteer',
      data: {
        'workId': workId,
      },
    );
  }

  @override
  Future<void> confirmByRequester(final String workId) async {
    await _dio.post(
      '$_basePath/confirm/requester',
      data: {
        'workId': workId,
      },
    );
  }

  @override
  Future<List<VolunteerWorkModel>> getWorksByVolunteer(
    final String volunteerId,
  ) async {
    final response = await _dio.get('$_basePath/volunteer/$volunteerId');
    return (response.data as List)
        .map(
          (final e) => VolunteerWorkModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<VolunteerWorkModel>> getWorksByRequester(
    final String requesterId,
  ) async {
    final response = await _dio.get('$_basePath/requester/$requesterId');
    return (response.data as List)
        .map(
          (final e) => VolunteerWorkModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }

  @override
  Future<List<VolunteerWorkModel>> getWorksByRequestId(
    final String requestId,
  ) async {
    final response = await _dio.get('$_basePath/request/$requestId');
    return (response.data as List)
        .map(
          (final e) => VolunteerWorkModel.fromJson(e as Map<String, dynamic>),
        )
        .toList();
  }
}
