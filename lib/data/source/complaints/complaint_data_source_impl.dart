import 'package:dio/dio.dart';
import 'package:simple_logger/simple_logger.dart';

import '../../models/request_complaint_model.dart';
import '../../models/request_complaints_group_model.dart';
import '../../models/user_complaint_model.dart';
import '../../models/user_complaints_group_model.dart';
import 'complaint_data_source.dart';

class ComplaintDataSourceImpl implements ComplaintDataSource {
  final Dio _dio;
  ComplaintDataSourceImpl(this._dio);

  static final logger = SimpleLogger();

  @override
  Future<List<RequestComplaintsGroupModel>> getRequestComplaintsGrouped(
    final String adminUserId,
  ) async {
    try {
      final response = await _dio.get(
        '/admin/complaints/grouped-requests',
        queryParameters: {'adminUserId': adminUserId},
      );

      final list = (response.data as List)
          .map(
            (final e) => RequestComplaintsGroupModel.fromJson(
              Map<String, dynamic>.from(e),
            ),
          )
          .toList();

      return list;
    } catch (e) {
      logger.severe('Failed to fetch request complaints grouped: $e');
      rethrow;
    }
  }

  @override
  Future<List<UserComplaintsGroupModel>> getUserComplaintsGrouped(
    final String adminUserId,
  ) async {
    try {
      final response = await _dio.get(
        '/admin/complaints/grouped-users',
        queryParameters: {'adminUserId': adminUserId},
      );

      final list = (response.data as List)
          .map(
            (final e) =>
                UserComplaintsGroupModel.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList();

      return list;
    } catch (e) {
      logger.severe('Failed to fetch user complaints grouped: $e');
      rethrow;
    }
  }

  @override
  Future<void> reportRequest(
    final RequestComplaintModel requestComplaintModel,
  ) async {
    await _dio.post(
      '/complaints/request',
      data: requestComplaintModel.toJson(),
    );
  }

  @override
  Future<void> reportUser(final UserComplaintModel userComplaintModel) async {
    await _dio.post(
      '/complaints/user',
      data: userComplaintModel.toJson(),
    );
  }
}
