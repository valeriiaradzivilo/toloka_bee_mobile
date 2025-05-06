import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../models/user_auth_model.dart';
import 'user_data_source.dart';

class UserDataSourceImpl implements UserDataSource {
  final Dio _dio;

  UserDataSourceImpl(this._dio);

  static const basePath = '/users';

  @override
  Future<UserAuthModel> getUserById(final String id) async {
    try {
      final response = await _dio.get(
        '$basePath/$id',
      );

      if (response.statusCode == 200) {
        return UserAuthModel.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch user');
      }
    } catch (e) {
      debugPrint('EXCEPTION: $e');
      throw Exception('Failed to fetch user: $e');
    }
  }
}
