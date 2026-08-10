// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_task_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetTaskResponse _$GetTaskResponseFromJson(Map<String, dynamic> json) =>
    GetTaskResponse(
      value: json['value'] == null
          ? null
          : GetTasValue.fromJson(json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$GetTaskResponseToJson(GetTaskResponse instance) =>
    <String, dynamic>{
      'value': instance.value,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

GetTasValue _$GetTasValueFromJson(Map<String, dynamic> json) => GetTasValue(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => GetTasData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      pageCount: (json['pageCount'] as num?)?.toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
      start: (json['start'] as num?)?.toInt(),
      end: (json['end'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetTasValueToJson(GetTasValue instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalCount': instance.totalCount,
      'pageCount': instance.pageCount,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'start': instance.start,
      'end': instance.end,
    };

GetTasData _$GetTasDataFromJson(Map<String, dynamic> json) => GetTasData(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      dueDate: json['dueDate'] as String?,
      priorityStatus: json['priorityStatus'] as String?,
      status: json['status'] as String?,
      employees: (json['employees'] as List<dynamic>?)
          ?.map(
              (e) => GetEmployeesForTheTask.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetTasDataToJson(GetTasData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dueDate': instance.dueDate,
      'priorityStatus': instance.priorityStatus,
      'status': instance.status,
      'employees': instance.employees,
    };

GetEmployeesForTheTask _$GetEmployeesForTheTaskFromJson(
        Map<String, dynamic> json) =>
    GetEmployeesForTheTask(
      position: json['position'] as String?,
      departmentName: json['departmentName'] as String?,
      departmentId: (json['departmentId'] as num?)?.toInt(),
      branchName: json['branchName'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      role: json['role'] as String?,
      canAddAttendance: json['canAddAttendance'] as bool?,
      canAddPlan: json['canAddPlan'] as bool?,
      id: json['id'] as String?,
      userName: json['userName'] as String?,
      name: json['name'] as String?,
      mobileId: json['mobileId'] as String?,
    );

Map<String, dynamic> _$GetEmployeesForTheTaskToJson(
        GetEmployeesForTheTask instance) =>
    <String, dynamic>{
      'position': instance.position,
      'departmentName': instance.departmentName,
      'departmentId': instance.departmentId,
      'branchName': instance.branchName,
      'branchId': instance.branchId,
      'role': instance.role,
      'canAddAttendance': instance.canAddAttendance,
      'canAddPlan': instance.canAddPlan,
      'id': instance.id,
      'userName': instance.userName,
      'name': instance.name,
      'mobileId': instance.mobileId,
    };
