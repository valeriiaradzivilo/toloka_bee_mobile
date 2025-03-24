import 'dart:convert';

import 'package:dio/dio.dart';

import '../../models/user_auth_model.dart';
import 'auth_data_source.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _dio;
  AuthDataSourceImpl(this._dio);

  static const _basePath = '/auth';

  @override
  Future<bool> login(final String username, final String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> register(final UserAuthModel user) async {
    try {
      final data = user.toJson();
      final response = await _dio.post(
        '$_basePath/register',
        data: jsonEncode(data),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        // Parse the response if needed
        final userRecord =
            response.data; // Assuming response contains UserRecord
        print('User registered successfully: $userRecord');
      } else {
        throw Exception('Failed to register user: ${response.statusCode}');
      }
    } catch (e) {
      // Handle errors appropriately
      print('Error during registration: $e');
      rethrow; // Optionally rethrow the error
    }
  }
}
