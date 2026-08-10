// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_attendance_summary_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeAttendanceSummaryRequestBody
    _$EmployeeAttendanceSummaryRequestBodyFromJson(Map<String, dynamic> json) =>
        EmployeeAttendanceSummaryRequestBody(
          employeeId: json['employeeId'] as String,
          month: (json['month'] as num).toInt(),
          year: (json['year'] as num).toInt(),
        );

Map<String, dynamic> _$EmployeeAttendanceSummaryRequestBodyToJson(
        EmployeeAttendanceSummaryRequestBody instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'month': instance.month,
      'year': instance.year,
    };
