// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_request_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaveRequestRequestBody _$LeaveRequestRequestBodyFromJson(
        Map<String, dynamic> json) =>
    LeaveRequestRequestBody(
      employeeId: json['employeeId'] as String,
      startDate: json['startDate'] as String,
      leaveRequestType: json['leaveRequestType'] as String,
      endDate: json['endDate'] as String,
      reason: json['reason'] as String,
      remark: json['remark'] as String,
    );

Map<String, dynamic> _$LeaveRequestRequestBodyToJson(
        LeaveRequestRequestBody instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'reason': instance.reason,
      'remark': instance.remark,
      'leaveRequestType': instance.leaveRequestType,
    };
