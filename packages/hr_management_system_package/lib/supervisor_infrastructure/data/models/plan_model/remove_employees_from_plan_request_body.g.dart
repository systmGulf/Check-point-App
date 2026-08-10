// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_employees_from_plan_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveEmployeesFromPlanRequestBody _$RemoveEmployeesFromPlanRequestBodyFromJson(
        Map<String, dynamic> json) =>
    RemoveEmployeesFromPlanRequestBody(
      employeeIds: json['employeeIds'] as String,
      customerPlanId: (json['customerPlanId'] as num).toInt(),
    );

Map<String, dynamic> _$RemoveEmployeesFromPlanRequestBodyToJson(
        RemoveEmployeesFromPlanRequestBody instance) =>
    <String, dynamic>{
      'employeeIds': instance.employeeIds,
      'customerPlanId': instance.customerPlanId,
    };
