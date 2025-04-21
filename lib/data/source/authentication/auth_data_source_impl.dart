import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_logger/simple_logger.dart';

import '../../../features/profile/bloc/profile_state.dart';
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
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: username, password: password);

      final String? idToken = userCredential.user?.uid;

      if (idToken == null) throw Exception('Failed to get ID token');

      return await getCurrentUserData(idToken: idToken);
    } catch (e) {
      logger.severe('Login failed: $e');
      await _auth.signOut();
      rethrow;
    }
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

  @override
  Future<void> updateUser(final ProfileUpdating user) async {
    if (user.oldPassword != null &&
        user.oldPassword!.isNotEmpty &&
        user.changedUser.password != null) {
      final credential = EmailAuthProvider.credential(
        email: user.changedUser.email,
        password: user.oldPassword!,
      );
      try {
        await _auth.currentUser?.reauthenticateWithCredential(credential);
      } catch (e) {
        throw Exception('Old password is incorrect');
      }
      await _auth.currentUser?.updatePassword(user.changedUser.password!);
    }

    final data = user.changedUser.toJson();

    final response = await _dio.put(
      '$_basePath/update',
      data: (data),
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteUser(final String userId) async {
    if (userId != FirebaseAuth.instance.currentUser?.uid) {
      throw Exception('You can only delete your own account');
    }

    await _auth.currentUser?.delete();
    await _auth.signOut();

    final response = await _dio.delete(
      '$_basePath/delete/$userId',
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user: ${response.statusCode}');
    }
  }
}
