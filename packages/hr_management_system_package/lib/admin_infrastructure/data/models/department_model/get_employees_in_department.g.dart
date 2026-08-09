// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_employees_in_department.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetEmployeesInDepartmentModel _$GetEmployeesInDepartmentModelFromJson(
        Map<String, dynamic> json) =>
    GetEmployeesInDepartmentModel(
      employeesPage: json['value'] == null
          ? null
          : GetEmployeesInDepartmentValue.fromJson(
              json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$GetEmployeesInDepartmentModelToJson(
        GetEmployeesInDepartmentModel instance) =>
    <String, dynamic>{
      'value': instance.employeesPage,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

GetEmployeesInDepartmentValue _$GetEmployeesInDepartmentValueFromJson(
        Map<String, dynamic> json) =>
    GetEmployeesInDepartmentValue(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) =>
              GetEmployeesInDepartmentData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      pageCount: (json['pageCount'] as num?)?.toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
      start: (json['start'] as num?)?.toInt(),
      end: (json['end'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetEmployeesInDepartmentValueToJson(
        GetEmployeesInDepartmentValue instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalCount': instance.totalCount,
      'pageCount': instance.pageCount,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'start': instance.start,
      'end': instance.end,
    };

GetEmployeesInDepartmentData _$GetEmployeesInDepartmentDataFromJson(
        Map<String, dynamic> json) =>
    GetEmployeesInDepartmentData(
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
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$GetEmployeesInDepartmentDataToJson(
        GetEmployeesInDepartmentData instance) =>
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
      'imageUrl': instance.imageUrl,
    };
