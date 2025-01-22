import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/location_model.dart';
import 'geo_data_source.dart';

class GeoDataSourceImp implements GeoDataSource {
  final String backendUrl = 'http://10.0.2.2:8080';
  late final Dio _dio = Dio(BaseOptions(baseUrl: backendUrl,
  sendTimeout: const Duration(seconds: 5),
  receiveTimeout: const Duration(seconds: 5),
  connectTimeout: const Duration(seconds: 5)));
  


  @override
  Future<void> updateLocation(LocationModel location) async {
    try {
      final response = await _dio.post(
        '/update-location',
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
