// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supervisor_employee_check_out_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupervisorEmployeeCheckOutRequestBody
    _$SupervisorEmployeeCheckOutRequestBodyFromJson(
            Map<String, dynamic> json) =>
        SupervisorEmployeeCheckOutRequestBody(
          employeeId: json['employeeId'] as String,
          employeeImage: json['employeeImage'] as String?,
        );

Map<String, dynamic> _$SupervisorEmployeeCheckOutRequestBodyToJson(
        SupervisorEmployeeCheckOutRequestBody instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'employeeImage': instance.employeeImage,
    };
