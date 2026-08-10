// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_request_leave_status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangeRequestLeaveStatus _$ChangeRequestLeaveStatusFromJson(
        Map<String, dynamic> json) =>
    ChangeRequestLeaveStatus(
      leaveRequestId: (json['leaveRequestId'] as num).toInt(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$ChangeRequestLeaveStatusToJson(
        ChangeRequestLeaveStatus instance) =>
    <String, dynamic>{
      'leaveRequestId': instance.leaveRequestId,
      'status': instance.status,
    };
