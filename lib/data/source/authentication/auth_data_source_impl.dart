import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:simple_logger/simple_logger.dart';

import '../../models/user_auth_model.dart';
import 'auth_data_source.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _dio;
  AuthDataSourceImpl(this._dio);

  static const _basePath = '/auth';
  static final logger = SimpleLogger();

  @override
  Future<UserAuthModel> login(
    final String username,
    final String password,
  ) async {
    final response = await _dio.post(
      '$_basePath/login',
      data: {
        'email': username,
        'password': password,
        'returnSecureToken': true,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode == 200) {
      final userRecord = response.data;
      logger.info('User logged in successfully...');
      return UserAuthModel.fromJson(userRecord);
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
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
