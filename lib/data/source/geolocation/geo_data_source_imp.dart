import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../models/location_model.dart';
import 'geo_data_source.dart';

class GeoDataSourceImp implements GeoDataSource {
  final Dio _dio;

  GeoDataSourceImp(this._dio);

  static const basePath = '/location';

  @override
  Future<void> updateLocation(LocationModel location) async {
    try {
      final response = await _dio.post(
        '$basePath/update-location',
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode(location.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send location');
      }
    } catch (e) {
      debugPrint('EXCEPTION: $e');
      throw Exception('Failed to send location: $e');
    }
  }
}
