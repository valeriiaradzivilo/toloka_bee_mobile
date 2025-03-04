import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../models/user_auth_model.dart';
import 'auth_data_source.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _dio;
  AuthDataSourceImpl(this._dio);

  static const _basePath = '/auth';

  @override
  Future<bool> login(String username, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> register(UserAuthModel user) async {
    try {
      final response = await _dio.post(
        '$_basePath/register',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode(user.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to register');
      }
    } catch (e) {
      debugPrint('EXCEPTION: $e');
      throw Exception('Failed to register: $e');
    }
  }
}
