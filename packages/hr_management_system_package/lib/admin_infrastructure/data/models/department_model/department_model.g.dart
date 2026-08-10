// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'department_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentModel _$DepartmentModelFromJson(Map<String, dynamic> json) =>
    DepartmentModel(
      departmentsPage: json['value'] == null
          ? null
          : DepartmentValue.fromJson(json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$DepartmentModelToJson(DepartmentModel instance) =>
    <String, dynamic>{
      'value': instance.departmentsPage,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

DepartmentValue _$DepartmentValueFromJson(Map<String, dynamic> json) =>
    DepartmentValue(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DepartmentData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      pageCount: (json['pageCount'] as num?)?.toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
      start: (json['start'] as num?)?.toInt(),
      end: (json['end'] as num?)?.toInt(),
    );

Map<String, dynamic> _$DepartmentValueToJson(DepartmentValue instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalCount': instance.totalCount,
      'pageCount': instance.pageCount,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'start': instance.start,
      'end': instance.end,
    };

DepartmentData _$DepartmentDataFromJson(Map<String, dynamic> json) =>
    DepartmentData(
      id: (json['id'] as num?)?.toInt(),
      departmentName: json['departmentName'] as String?,
      employees: (json['employees'] as List<dynamic>?)
          ?.map(
              (e) => EmployeesInDepartment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DepartmentDataToJson(DepartmentData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'departmentName': instance.departmentName,
      'employees': instance.employees,
    };

EmployeesInDepartment _$EmployeesInDepartmentFromJson(
        Map<String, dynamic> json) =>
    EmployeesInDepartment(
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

Map<String, dynamic> _$EmployeesInDepartmentToJson(
        EmployeesInDepartment instance) =>
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
