// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_employee_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddEmployeeRequestBody _$AddEmployeeRequestBodyFromJson(
        Map<String, dynamic> json) =>
    AddEmployeeRequestBody(
      (json['deviceTokens'] as List<dynamic>).map((e) => e as String).toList(),
      name: json['name'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      position: json['position'] as String,
      branchId: (json['branchId'] as num).toInt(),
      mobileId: json['mobileId'] as String,
      departmentId: (json['departmentId'] as num).toInt(),
      role: json['role'] as String,
    );

Map<String, dynamic> _$AddEmployeeRequestBodyToJson(
        AddEmployeeRequestBody instance) =>
    <String, dynamic>{
      'name': instance.name,
      'username': instance.username,
      'password': instance.password,
      'position': instance.position,
      'mobileId': instance.mobileId,
      'role': instance.role,
      'departmentId': instance.departmentId,
      'branchId': instance.branchId,
      'deviceTokens': instance.deviceTokens,
    };
