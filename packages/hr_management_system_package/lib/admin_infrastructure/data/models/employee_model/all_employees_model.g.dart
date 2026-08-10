// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_employees_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllEmployeesModel _$AllEmployeesModelFromJson(Map<String, dynamic> json) =>
    AllEmployeesModel(
      employeesPage: json['value'] == null
          ? null
          : GetAllEmployeesValue.fromJson(
              json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$AllEmployeesModelToJson(AllEmployeesModel instance) =>
    <String, dynamic>{
      'value': instance.employeesPage,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

GetAllEmployeesValue _$GetAllEmployeesValueFromJson(
        Map<String, dynamic> json) =>
    GetAllEmployeesValue(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => EmployeeData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      pageCount: (json['pageCount'] as num?)?.toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
      start: (json['start'] as num?)?.toInt(),
      end: (json['end'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetAllEmployeesValueToJson(
        GetAllEmployeesValue instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalCount': instance.totalCount,
      'pageCount': instance.pageCount,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'start': instance.start,
      'end': instance.end,
    };

EmployeeData _$EmployeeDataFromJson(Map<String, dynamic> json) => EmployeeData(
      position: json['position'] as String?,
      departmentName: json['departmentName'] as String?,
      departmentId: (json['departmentId'] as num?)?.toInt(),
      branchName: json['branchName'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      role: json['role'] as String?,
      canAddAttendance: json['canAddAttendance'] as bool?,
      canAddPlan: json['canAddPlan'] as bool?,
      shiftName: json['shiftName'] as String?,
      month: (json['month'] as num?)?.toInt(),
      year: (json['year'] as num?)?.toInt(),
      clockInTime: json['clockInTime'] as String?,
      clockOutTime: json['clockOutTime'] as String?,
      area: json['area'] as String?,
      id: json['id'] as String?,
      userName: json['userName'] as String?,
      name: json['name'] as String?,
      mobileId: json['mobileId'] as String?,
      deviceTokens: (json['deviceTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$EmployeeDataToJson(EmployeeData instance) =>
    <String, dynamic>{
      'position': instance.position,
      'departmentName': instance.departmentName,
      'departmentId': instance.departmentId,
      'branchName': instance.branchName,
      'branchId': instance.branchId,
      'role': instance.role,
      'canAddAttendance': instance.canAddAttendance,
      'canAddPlan': instance.canAddPlan,
      'shiftName': instance.shiftName,
      'month': instance.month,
      'year': instance.year,
      'clockInTime': instance.clockInTime,
      'clockOutTime': instance.clockOutTime,
      'area': instance.area,
      'id': instance.id,
      'userName': instance.userName,
      'name': instance.name,
      'mobileId': instance.mobileId,
      'deviceTokens': instance.deviceTokens,
      'imageUrl': instance.imageUrl,
    };
