import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_logger/simple_logger.dart';

import '../../models/user_auth_model.dart';
import 'auth_data_source.dart';

class AuthDataSourceImpl implements AuthDataSource {
  final Dio _dio;
  AuthDataSourceImpl(this._dio);

  static const _basePath = '/auth';

  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final logger = SimpleLogger();

  @override
  Future<UserAuthModel> login(
    final String username,
    final String password,
  ) async {
    final UserCredential userCredential = await _auth
        .signInWithEmailAndPassword(email: username, password: password);

    final String? idToken = userCredential.user?.uid;

    if (idToken == null) throw Exception('Failed to get ID token');

    return await getCurrentUserData(idToken: idToken);
  }

  @override
  Future<void> logout() => _auth.signOut();

  @override
  Future<void> register(final UserAuthModel user) async {
    if (user.password == null) {
      throw Exception('Password is required');
    }

    final UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
      email: user.email,
      password: user.password!,
    );

    if (userCredential.user == null) {
      throw Exception('Failed to create user');
    }

    final data = user
        .copyWith(
          id: userCredential.user!.uid,
          password: null,
        )
        .toJson();

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
      final userRecord = response.data;
      logger.info('User registered successfully: $userRecord');
    } else {
      throw Exception('Failed to register user: ${response.statusCode}');
    }
  }

  @override
  Future<String> getAccessToken() async {
    final User? user = _auth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final idToken = await _dio.post(
      '$_basePath/access-token',
      data: {
        'id': user.uid,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    return idToken.data as String? ?? '';
  }

  @override
  Future<UserAuthModel> getCurrentUserData({final String? idToken}) async {
    if (idToken == null && FirebaseAuth.instance.currentUser == null) {
      throw Exception('User is not logged in');
    }

    final response = await _dio.post(
      '$_basePath/login',
      data: {
        'id': idToken ?? FirebaseAuth.instance.currentUser?.uid,
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
}
