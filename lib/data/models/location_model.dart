import 'package:freezed_annotation/freezed_annotation.dart';

part '../../generated/data/models/location_model.freezed.dart';
part '../../generated/data/models/location_model.g.dart';

@freezed
class LocationModel with _$LocationModel {
  factory LocationModel({required double latitude, required double longitude}) = _LocationModel;

  factory LocationModel.fromJson(Map<String, dynamic> json) => _$LocationModelFromJson(json);
}
