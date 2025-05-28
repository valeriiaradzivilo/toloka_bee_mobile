import 'package:dio/dio.dart';

import '../../models/e_request_status.dart';
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
  Future<void> confirmByRequester(
    final String workId,
    final String requestId,
  ) async {
    await _dio.post(
      '$_basePath/confirm/requester',
      data: {
        'workId': workId,
        'requestId': requestId,
        'status': ERequestStatus.completed.name.toLowerCase(),
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

  @override
  Future<void> cancelHelping(final String workId) async {
    await _dio.post(
      '$_basePath/cancel',
      data: {
        'workId': workId,
        'newStatus': ERequestStatus.pending.name,
      },
    );
  }

  @override
  Future<VolunteerWorkModel> getWorkById(final String id) =>
      _dio.get('$_basePath/$id').then((final response) {
        if (response.statusCode == 200) {
          return VolunteerWorkModel.fromJson(response.data);
        } else {
          throw Exception(
            'Failed to get work by id: ${response.statusCode}',
          );
        }
      });
}
