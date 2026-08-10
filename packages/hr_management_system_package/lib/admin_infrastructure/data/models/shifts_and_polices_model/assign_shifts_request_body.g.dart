// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_shifts_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssignShiftsRequestBody _$AssignShiftsRequestBodyFromJson(
        Map<String, dynamic> json) =>
    AssignShiftsRequestBody(
      shiftId: (json['shiftId'] as num).toInt(),
      branchesIds: (json['branchesIds'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
    );

Map<String, dynamic> _$AssignShiftsRequestBodyToJson(
        AssignShiftsRequestBody instance) =>
    <String, dynamic>{
      'shiftId': instance.shiftId,
      'branchesIds': instance.branchesIds,
    };

AssignPoliceRequestBody _$AssignPoliceRequestBodyFromJson(
        Map<String, dynamic> json) =>
    AssignPoliceRequestBody(
      policyId: (json['policyId'] as num).toInt(),
      employeeIds: (json['employeeIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$AssignPoliceRequestBodyToJson(
        AssignPoliceRequestBody instance) =>
    <String, dynamic>{
      'policyId': instance.policyId,
      'employeeIds': instance.employeeIds,
    };

RemoveAssignPolicyRequestBody _$RemoveAssignPolicyRequestBodyFromJson(
        Map<String, dynamic> json) =>
    RemoveAssignPolicyRequestBody(
      employeeId: json['employeeId'] as String,
      policyId: (json['policyId'] as num).toInt(),
    );

Map<String, dynamic> _$RemoveAssignPolicyRequestBodyToJson(
        RemoveAssignPolicyRequestBody instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'policyId': instance.policyId,
    };
