// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_branch_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddBrachRequestBody _$AddBrachRequestBodyFromJson(Map<String, dynamic> json) =>
    AddBrachRequestBody(
      name: json['name'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => LocationFrameLatLng.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AddBrachRequestBodyToJson(
        AddBrachRequestBody instance) =>
    <String, dynamic>{
      'name': instance.name,
      'location': instance.location,
      'description': instance.description,
      'coordinates': instance.coordinates.map((e) => e.toJson()).toList(),
    };

LocationFrameLatLng _$LocationFrameLatLngFromJson(Map<String, dynamic> json) =>
    LocationFrameLatLng(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$LocationFrameLatLngToJson(
        LocationFrameLatLng instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
