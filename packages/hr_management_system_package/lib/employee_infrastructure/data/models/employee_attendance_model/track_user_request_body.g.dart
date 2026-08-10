// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_user_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackUserRequestBody _$TrackUserRequestBodyFromJson(
        Map<String, dynamic> json) =>
    TrackUserRequestBody(
      employeeId: json['employeeId'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
    );

Map<String, dynamic> _$TrackUserRequestBodyToJson(
        TrackUserRequestBody instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'coordinates': instance.coordinates,
    };
