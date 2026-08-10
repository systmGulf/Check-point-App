// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employee_tasks_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeeTasksResponseBody _$EmployeeTasksResponseBodyFromJson(
        Map<String, dynamic> json) =>
    EmployeeTasksResponseBody(
      value: json['value'] == null
          ? null
          : Value.fromJson(json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$EmployeeTasksResponseBodyToJson(
        EmployeeTasksResponseBody instance) =>
    <String, dynamic>{
      'value': instance.value,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

Value _$ValueFromJson(Map<String, dynamic> json) => Value(
      userName: json['userName'] as String?,
      imageUrl: json['imageUrl'] as String?,
      employeeTasks: (json['employeeTasks'] as List<dynamic>?)
          ?.map((e) => EmployeeTasks.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
      'userName': instance.userName,
      'imageUrl': instance.imageUrl,
      'employeeTasks': instance.employeeTasks,
    };

EmployeeTasks _$EmployeeTasksFromJson(Map<String, dynamic> json) =>
    EmployeeTasks(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      dueDate: json['dueDate'] as String?,
      priorityStatus: json['priorityStatus'] as String?,
      status: json['status'] as String?,
      employees: (json['employees'] as List<dynamic>?)
          ?.map((e) => Employees.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EmployeeTasksToJson(EmployeeTasks instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'dueDate': instance.dueDate,
      'priorityStatus': instance.priorityStatus,
      'status': instance.status,
      'employees': instance.employees,
    };

Employees _$EmployeesFromJson(Map<String, dynamic> json) => Employees(
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
      deviceTokens: (json['deviceTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$EmployeesToJson(Employees instance) => <String, dynamic>{
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
      'deviceTokens': instance.deviceTokens,
      'imageUrl': instance.imageUrl,
    };
