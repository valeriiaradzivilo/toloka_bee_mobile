import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:simple_logger/simple_logger.dart';

import '../../../common/exceptions/user_blocked_exception.dart';
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

      final user = await getCurrentUserData(idToken: idToken);

      if (user.bannedUntil != null &&
          user.bannedUntil!.isAfter(DateTime.now())) {
        await _auth.signOut();
        throw UserBlockedException(user.bannedUntil!);
      }

      return user;
    } catch (e) {
      logger.severe('Login failed: $e');
      await _auth.signOut();
      rethrow;
    }
  }

  @override
  Future<void> logout() => _auth.signOut();

  @override
  Future<String> register(final UserAuthModel user) async {
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
    );

    if (response.statusCode == 200) {
      final userRecord = response.data;
      if (userRecord is String && userRecord.isNotEmpty) {
        return userRecord;
      }
    }

    throw Exception('Failed to register user: ${response.statusCode}');
  }

  @override
  Future<String> getFirebaseMessagingAccessToken() async {
    final jsonString =
        await rootBundle.loadString('assets/serviceAccount.json');
    final Map<String, dynamic> serviceJson = json.decode(jsonString);

    final credentials = ServiceAccountCredentials.fromJson(serviceJson);

    final client = http.Client();
    final accessCredentials = await obtainAccessCredentialsViaServiceAccount(
      credentials,
      ['https://www.googleapis.com/auth/firebase.messaging'],
      client,
    );

    client.close();
    return accessCredentials.accessToken.data;
  }

  @override
  Future<UserAuthModel> getCurrentUserData({final String? idToken}) async {
    if (idToken == null && _auth.currentUser == null) {
      throw Exception('User is not logged in');
    }

    final response = await _dio.post(
      '$_basePath/login',
      data: {
        'id': idToken ?? _auth.currentUser?.uid,
      },
    );

    if (response.statusCode == 200) {
      final userRecord = response.data;
      userRecord['isAdmin'] = await _isAdmin(userRecord['id']);
      logger.info('User logged in successfully...');
      return UserAuthModel.fromJson(userRecord);
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<bool> _isAdmin(final String userId) async {
    try {
      final response = await _dio.get(
        '/admin/is-admin/$userId',
      );

      if (response.statusCode == 200) {
        return response.data == true;
      } else {
        return false;
      }
    } catch (e) {
      logger.severe('Failed to check if user is admin: $e');
      return false;
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
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update user: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteUser(final String userId) async {
    if (userId != _auth.currentUser?.uid) {
      throw Exception('You can only delete your own account');
    }

    await _auth.currentUser?.delete();
    await _auth.signOut();

    final response = await _dio.delete(
      '$_basePath/delete/$userId',
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete user: ${response.statusCode}');
    }
  }

  //TODO: якщо запитувач не підтверджує виконання запиту, то запит запускається повторно;
  //TODO: якщо волонтера не знайдено, або ніхто не прийняв запит до кінця дедлайну, система циклічно перевіряє: «Час вийшов?». У разі перевищення терміну запит отримує статус «Expired» та надсилається відповідне сповіщення автору;

  @override
  Future<String> getUserIdToken() async {
    final user = _auth.currentUser;
    if (user != null) {
      return await user.getIdToken() ?? '';
    } else {
      throw Exception('User is not logged in');
    }
  }
}
