import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../di.dart';
import '../../models/user_auth_model.dart';
import '../authentication/auth_data_source.dart';
import 'user_data_source.dart';

class UserDataSourceImpl implements UserDataSource {
  final Dio _dio;

  UserDataSourceImpl(this._dio);

  static const basePath = '/users';

  @override
  Future<UserAuthModel> getUserById(final String id) async {
    try {
      final accessToken =
          await serviceLocator<AuthDataSource>().getAccessToken();

      if (accessToken.isEmpty) {
        throw Exception('Access token is null');
      }

      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final response = await _dio.get(
        '$basePath/$id',
        options: Options(headers: headers),
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
