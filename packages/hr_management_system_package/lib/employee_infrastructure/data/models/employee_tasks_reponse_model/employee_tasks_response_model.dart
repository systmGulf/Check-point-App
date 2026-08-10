import 'package:freezed_annotation/freezed_annotation.dart';
part 'employee_tasks_response_model.g.dart';
@JsonSerializable()
class EmployeeTasksResponseBody {
  Value? value;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  EmployeeTasksResponseBody(
      {this.value,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});

  factory EmployeeTasksResponseBody.fromJson(Map<String, dynamic> json) => _$EmployeeTasksResponseBodyFromJson(json);
}
@JsonSerializable()
class Value {
  String? userName;
  String? imageUrl;
  List<EmployeeTasks>? employeeTasks;

  Value({this.userName, this.imageUrl, this.employeeTasks});

   factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);
}
@JsonSerializable()
class EmployeeTasks {
  int? id;
  String? title;
  String? description;
  String? dueDate;
  String? priorityStatus;
  String? status;
  List<Employees>? employees;

  EmployeeTasks(
      {this.id,
      this.title,
      this.description,
      this.dueDate,
      this.priorityStatus,
      this.status,
      this.employees});
  factory EmployeeTasks.fromJson(Map<String, dynamic> json) => _$EmployeeTasksFromJson(json);
}
@JsonSerializable()
class Employees {
  String? position;
  String? departmentName;
  int? departmentId;
  String? branchName;
  int? branchId;
  String? role;
  bool? canAddAttendance;
  bool? canAddPlan;
  String? id;
  String? userName;
  String? name;
  String? mobileId;
  List<String>? deviceTokens;
  String? imageUrl;

  Employees(
      {this.position,
      this.departmentName,
      this.departmentId,
      this.branchName,
      this.branchId,
      this.role,
      this.canAddAttendance,
      this.canAddPlan,
      this.id,
      this.userName,
      this.name,
      this.mobileId,
      this.deviceTokens,
      this.imageUrl});
  factory Employees.fromJson(Map<String, dynamic> json) => _$EmployeesFromJson(json);
}