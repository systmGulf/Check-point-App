import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_task_response.g.dart';

@JsonSerializable()
class GetTaskResponse {
  GetTasValue? value;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  GetTaskResponse(
      {this.value,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});
  factory GetTaskResponse.fromJson(Map<String, dynamic> json) =>
      _$GetTaskResponseFromJson(json);
}

@JsonSerializable()
class GetTasValue {
  List<GetTasData>? data;
  int? totalCount;
  int? pageCount;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? start;
  int? end;

  GetTasValue(
      {this.data,
      this.totalCount,
      this.pageCount,
      this.hasNextPage,
      this.hasPreviousPage,
      this.start,
      this.end});

  factory GetTasValue.fromJson(Map<String, dynamic> json) =>
      _$GetTasValueFromJson(json);
}

@JsonSerializable()
class GetTasData {
  int? id;
  String? title;
  String? description;
  String? dueDate;
  String? priorityStatus;
  String? status;
  List<GetEmployeesForTheTask>? employees;

  GetTasData(
      {this.id,
      this.title,
      this.description,
      this.dueDate,
      this.priorityStatus,
      this.status,
      this.employees});

  factory GetTasData.fromJson(Map<String, dynamic> json) =>
      _$GetTasDataFromJson(json);
}

@JsonSerializable()
class GetEmployeesForTheTask {
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

  GetEmployeesForTheTask(
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
      this.mobileId});

  factory GetEmployeesForTheTask.fromJson(Map<String, dynamic> json) =>
      _$GetEmployeesForTheTaskFromJson(json);
}
