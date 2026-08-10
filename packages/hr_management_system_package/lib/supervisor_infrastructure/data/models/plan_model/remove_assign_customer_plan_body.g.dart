// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_assign_customer_plan_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveAssignCustomerPlanBody _$RemoveAssignCustomerPlanBodyFromJson(
        Map<String, dynamic> json) =>
    RemoveAssignCustomerPlanBody(
      employeeId: json['employeeId'] as String,
      customerPlanId: (json['customerPlanId'] as num).toInt(),
    );

Map<String, dynamic> _$RemoveAssignCustomerPlanBodyToJson(
        RemoveAssignCustomerPlanBody instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'customerPlanId': instance.customerPlanId,
    };
