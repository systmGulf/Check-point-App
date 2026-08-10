// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_check_out_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeCheckOutRequestBody _$EmployeeCheckOutRequestBodyFromJson(
        Map<String, dynamic> json) =>
    EmployeeCheckOutRequestBody(
      employeeId: json['employeeId'] as String,
      employeeImage: json['employeeImage'] as String?,
    );

Map<String, dynamic> _$EmployeeCheckOutRequestBodyToJson(
        EmployeeCheckOutRequestBody instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'employeeImage': instance.employeeImage,
    };
