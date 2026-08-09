// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_check_in_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeCheckInRequestBody _$EmployeeCheckInRequestBodyFromJson(
        Map<String, dynamic> json) =>
    EmployeeCheckInRequestBody(
      json['customerId'] as String?,
      json['employeeImage'] as String?,
      employeeIdd: json['employeeId'] as String,
      area: json['area'] as String,
      location: json['location'] as String,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => AttendanceCoordinate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EmployeeCheckInRequestBodyToJson(
        EmployeeCheckInRequestBody instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeIdd,
      'area': instance.area,
      'customerId': instance.customerId,
      'location': instance.location,
      'employeeImage': instance.employeeImage,
      'coordinates': instance.coordinates,
    };

AttendanceCoordinate _$AttendanceCoordinateFromJson(
        Map<String, dynamic> json) =>
    AttendanceCoordinate(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$AttendanceCoordinateToJson(
        AttendanceCoordinate instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
