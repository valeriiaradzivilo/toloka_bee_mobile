import 'dart:convert';

import 'package:dio/dio.dart';

import '../../models/contact_info_model.dart';
import 'contacts_data_source.dart';

class ContactsDataSourceImpl implements ContactsDataSource {
  final Dio _dio;
  ContactsDataSourceImpl(this._dio);
  static const _basePath = '/contact';

  @override
  Future<ContactInfoModel> saveContact(final ContactInfoModel info) async {
    final response = await _dio.post(
      '$_basePath/save',
      data: jsonEncode(info.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode == 200) {
      return ContactInfoModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to save contact: ${response.statusCode} ${response.statusMessage}',
      );
    }
  }

  @override
  Future<void> updateContact(final ContactInfoModel info) async {
    final response = await _dio.post(
      '$_basePath/update',
      data: jsonEncode(info.toJson()),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to update contact: ${response.statusCode} ${response.statusMessage}',
      );
    }
  }

  @override
  Future<ContactInfoModel> getContactById(final String id) async {
    final response = await _dio.get(
      '$_basePath/get/$id',
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode == 200) {
      return ContactInfoModel.fromJson(response.data);
    } else {
      throw Exception(
        'Failed to fetch contact by id: ${response.statusCode} ${response.statusMessage}',
      );
    }
  }

  @override
  Future<ContactInfoModel?> getContactByUserId(final String userId) async {
    final response = await _dio.get(
      '$_basePath/get-by-user/$userId',
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode == 200 && response.data != null) {
      return ContactInfoModel.fromJson(response.data);
    } else if (response.statusCode == 404) {
      return null;
    } else {
      throw Exception(
        'Failed to fetch contact by userId: ${response.statusCode} ${response.statusMessage}',
      );
    }
  }

  @override
  Future<void> deleteContactById(final String id) async {
    final response = await _dio.delete(
      '$_basePath/delete/$id',
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Failed to delete contact: ${response.statusCode} ${response.statusMessage}',
      );
    }
  }
}
