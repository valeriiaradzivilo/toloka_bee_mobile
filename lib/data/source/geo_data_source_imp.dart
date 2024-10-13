import 'dart:convert';

import 'package:dio/dio.dart';
import '../models/location_model.dart';
import 'geo_data_source.dart';

class GeoDataSourceImp implements GeoDataSource {
  final String backendUrl = 'http://localhost:8080';
  final Dio _dio = Dio();

  @override
  Future<void> updateLocation(LocationModel location) async {
    try {
      final updateLocationUrl = '$backendUrl/update-location';
      final response = await _dio.post(
        updateLocationUrl,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: jsonEncode(location.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send location');
      }
    } catch (e) {
      throw Exception('Failed to send location: $e');
    }
  }
}
