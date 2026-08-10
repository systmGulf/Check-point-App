// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_summary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeSummary _$EmployeeSummaryFromJson(Map<String, dynamic> json) =>
    EmployeeSummary(
      summary: json['value'] == null
          ? null
          : EmployeeSummaryValue.fromJson(
              json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$EmployeeSummaryToJson(EmployeeSummary instance) =>
    <String, dynamic>{
      'value': instance.summary,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

EmployeeSummaryValue _$EmployeeSummaryValueFromJson(
        Map<String, dynamic> json) =>
    EmployeeSummaryValue(
      date: json['date'] as String?,
      employeeId: json['employeeId'] as String?,
      employeeName: json['employeeName'] as String?,
      totalHoursWorked: (json['totalHoursWorked'] as num?)?.toDouble(),
      totalDaysWorked: (json['totalDaysWorked'] as num?)?.toInt(),
      totalLateDays: (json['totalLateDays'] as num?)?.toInt(),
      employeeImage: json['employeeImage'] as String?,
      totalEarlyLeaveDays: (json['totalEarlyLeaveDays'] as num?)?.toInt(),
      totalAbsentDays: (json['totalAbsentDays'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EmployeeSummaryValueToJson(
        EmployeeSummaryValue instance) =>
    <String, dynamic>{
      'date': instance.date,
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'employeeImage': instance.employeeImage,
      'totalHoursWorked': instance.totalHoursWorked,
      'totalDaysWorked': instance.totalDaysWorked,
      'totalLateDays': instance.totalLateDays,
      'totalEarlyLeaveDays': instance.totalEarlyLeaveDays,
      'totalAbsentDays': instance.totalAbsentDays,
    };
