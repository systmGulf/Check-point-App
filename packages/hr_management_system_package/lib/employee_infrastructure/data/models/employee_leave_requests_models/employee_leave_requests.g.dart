// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_leave_requests.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeLeaveRequestsModel _$EmployeeLeaveRequestsModelFromJson(
        Map<String, dynamic> json) =>
    EmployeeLeaveRequestsModel(
      leaveRequestsPage: json['value'] == null
          ? null
          : EmployeeLeaveRequestsValue.fromJson(
              json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$EmployeeLeaveRequestsModelToJson(
        EmployeeLeaveRequestsModel instance) =>
    <String, dynamic>{
      'value': instance.leaveRequestsPage,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

EmployeeLeaveRequestsValue _$EmployeeLeaveRequestsValueFromJson(
        Map<String, dynamic> json) =>
    EmployeeLeaveRequestsValue(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              EmployeeLeaveRequestsData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      pageCount: (json['pageCount'] as num?)?.toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
      start: (json['start'] as num?)?.toInt(),
      end: (json['end'] as num?)?.toInt(),
    );

Map<String, dynamic> _$EmployeeLeaveRequestsValueToJson(
        EmployeeLeaveRequestsValue instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalCount': instance.totalCount,
      'pageCount': instance.pageCount,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'start': instance.start,
      'end': instance.end,
    };

EmployeeLeaveRequestsData _$EmployeeLeaveRequestsDataFromJson(
        Map<String, dynamic> json) =>
    EmployeeLeaveRequestsData(
      id: (json['id'] as num?)?.toInt(),
      startDate: json['startDate'] as String?,
      endDate: json['endDate'] as String?,
      reason: json['reason'] as String?,
      remark: json['remark'] as String?,
      status: json['status'] as String?,
      leaveRequestType: json['leaveRequestType'] as String?,
      employeeId: json['employeeId'] as String?,
      employeeName: json['employeeName'] as String?,
      createdDate: json['createdDate'] as String?,
      createdBy: json['createdBy'] as String?,
    );

Map<String, dynamic> _$EmployeeLeaveRequestsDataToJson(
        EmployeeLeaveRequestsData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'reason': instance.reason,
      'remark': instance.remark,
      'status': instance.status,
      'leaveRequestType': instance.leaveRequestType,
      'employeeId': instance.employeeId,
      'employeeName': instance.employeeName,
      'createdDate': instance.createdDate,
      'createdBy': instance.createdBy,
    };
