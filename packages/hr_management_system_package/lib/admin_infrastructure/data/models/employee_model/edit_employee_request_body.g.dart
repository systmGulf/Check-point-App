// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'edit_employee_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditEmployeeRequestBody _$EditEmployeeRequestBodyFromJson(
        Map<String, dynamic> json) =>
    EditEmployeeRequestBody(
      branchId: (json['branchId'] as num).toInt(),
      name: json['name'] as String,
      position: json['position'] as String,
      mobileId: json['mobileId'] as String,
      userName: json['userName'] as String,
      password: json['password'] as String,
      role: json['role'] as String,
      departmentId: (json['departmentId'] as num).toInt(),
    );

Map<String, dynamic> _$EditEmployeeRequestBodyToJson(
        EditEmployeeRequestBody instance) =>
    <String, dynamic>{
      'name': instance.name,
      'userName': instance.userName,
      'position': instance.position,
      'mobileId': instance.mobileId,
      'password': instance.password,
      'role': instance.role,
      'departmentId': instance.departmentId,
      'branchId': instance.branchId,
    };
