import 'package:freezed_annotation/freezed_annotation.dart';

part 'department_model.g.dart';
@JsonSerializable()
class DepartmentModel {
  @JsonKey(name: 'value')
  DepartmentValue? departmentsPage;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  DepartmentModel(
      {this.departmentsPage,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});

  factory DepartmentModel.fromJson(Map<String, dynamic> json) => _$DepartmentModelFromJson(json);

  @Deprecated('Use departmentsPage instead.')
  DepartmentValue? get value => departmentsPage;

  DepartmentValue get departmentsPageOrEmpty =>
      departmentsPage ?? DepartmentValue();
}
@JsonSerializable()

class DepartmentValue {
  List<DepartmentData>? data;
  int? totalCount;
  int? pageCount;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? start;
  int? end;

  DepartmentValue(
      {this.data,
      this.totalCount,
      this.pageCount,
      this.hasNextPage,
      this.hasPreviousPage,
      this.start,
      this.end});

  factory DepartmentValue.fromJson(Map<String, dynamic> json) => _$DepartmentValueFromJson(json);
}
@JsonSerializable()

class DepartmentData {
  int? id;
  String? departmentName;
  List<EmployeesInDepartment>? employees;

  DepartmentData({this.id, this.departmentName, this.employees});

  factory DepartmentData.fromJson(Map<String, dynamic> json) => _$DepartmentDataFromJson(json);
}
@JsonSerializable()

class EmployeesInDepartment {
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

  EmployeesInDepartment(
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

  factory EmployeesInDepartment.fromJson(Map<String, dynamic> json) => _$EmployeesInDepartmentFromJson(json);
}

typedef DepartmentsResponse = DepartmentModel;
typedef DepartmentsPage = DepartmentValue;
