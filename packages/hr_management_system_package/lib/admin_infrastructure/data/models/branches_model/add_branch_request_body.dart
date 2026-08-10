import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_branch_request_body.g.dart';

@JsonSerializable(explicitToJson: true)
class AddBrachRequestBody {
  final String name;
  final String location;
  final String description;
  final List<LocationFrameLatLng> coordinates;

  AddBrachRequestBody({
    required this.name,
    required this.location,
    required this.description,
    required this.coordinates,
  });

  Map<String, dynamic> toJson() => _$AddBrachRequestBodyToJson(this);
  factory AddBrachRequestBody.fromJson(Map<String, dynamic> json) =>
      _$AddBrachRequestBodyFromJson(json);
}

@JsonSerializable()
class LocationFrameLatLng {
  final double latitude;
  final double longitude;

  LocationFrameLatLng({required this.latitude, required this.longitude});

  Map<String, dynamic> toJson() => _$LocationFrameLatLngToJson(this);
  factory LocationFrameLatLng.fromJson(Map<String, dynamic> json) =>
      _$LocationFrameLatLngFromJson(json);
}
