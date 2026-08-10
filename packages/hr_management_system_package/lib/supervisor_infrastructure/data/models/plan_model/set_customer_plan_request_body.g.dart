// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_customer_plan_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SetCustomerPlanRequestBody _$SetCustomerPlanRequestBodyFromJson(
        Map<String, dynamic> json) =>
    SetCustomerPlanRequestBody(
      planDate: json['planDate'] as String,
      note: json['note'] as String,
      employeeIds: (json['employeeIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      customerId: json['customerId'] as String,
    );

Map<String, dynamic> _$SetCustomerPlanRequestBodyToJson(
        SetCustomerPlanRequestBody instance) =>
    <String, dynamic>{
      'planDate': instance.planDate,
      'note': instance.note,
      'employeeIds': instance.employeeIds,
      'customerId': instance.customerId,
    };

SetPlanByDateRequestBody _$SetPlanByDateRequestBodyFromJson(
        Map<String, dynamic> json) =>
    SetPlanByDateRequestBody(
      planDate: json['planDate'] as String,
      note: json['note'] as String,
      departmentId: json['departmentId'] as String,
    );

Map<String, dynamic> _$SetPlanByDateRequestBodyToJson(
        SetPlanByDateRequestBody instance) =>
    <String, dynamic>{
      'planDate': instance.planDate,
      'note': instance.note,
      'departmentId': instance.departmentId,
    };

SetSubPlansRequestBody _$SetSubPlansRequestBodyFromJson(
        Map<String, dynamic> json) =>
    SetSubPlansRequestBody(
      note: json['note'] as String,
      employeeIds: (json['employeeIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      customerIdOrSiteId: json['customerId'] as String,
      planId: (json['planId'] as num).toInt(),
    );

Map<String, dynamic> _$SetSubPlansRequestBodyToJson(
        SetSubPlansRequestBody instance) =>
    <String, dynamic>{
      'note': instance.note,
      'employeeIds': instance.employeeIds,
      'customerId': instance.customerIdOrSiteId,
      'planId': instance.planId,
    };
