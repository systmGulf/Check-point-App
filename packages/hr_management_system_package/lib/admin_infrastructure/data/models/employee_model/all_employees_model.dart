import 'package:freezed_annotation/freezed_annotation.dart';

part 'all_employees_model.g.dart';

@JsonSerializable()
class AllEmployeesModel {
  @JsonKey(name: 'value')
  GetAllEmployeesValue? employeesPage;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  AllEmployeesModel(
      {this.employeesPage,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});

  factory AllEmployeesModel.fromJson(Map<String, dynamic> json) =>
      _$AllEmployeesModelFromJson(json);

  @Deprecated('Use employeesPage instead.')
  GetAllEmployeesValue? get value => employeesPage;

  GetAllEmployeesValue get employeesPageOrEmpty =>
      employeesPage ?? GetAllEmployeesValue();
}

@JsonSerializable()
class GetAllEmployeesValue {
  List<EmployeeData>? data;
  int? totalCount;
  int? pageCount;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? start;
  int? end;

  GetAllEmployeesValue(
      {this.data,
      this.totalCount,
      this.pageCount,
      this.hasNextPage,
      this.hasPreviousPage,
      this.start,
      this.end});
  factory GetAllEmployeesValue.fromJson(Map<String, dynamic> json) =>
      _$GetAllEmployeesValueFromJson(json);
}

@JsonSerializable()
class EmployeeData {
  String? position;
  String? departmentName;
  int? departmentId;
  String? branchName;
  int? branchId;
  String? role;
  bool? canAddAttendance;
  bool? canAddPlan;
  String? shiftName;
  int? month;
  int? year;
  String? clockInTime;
  String? clockOutTime;
  String? area;
  String? id;
  String? userName;
  String? name;
  String? mobileId;
  List<String>? deviceTokens;
  String? imageUrl;

  EmployeeData(
      {this.position,
      this.departmentName,
      this.departmentId,
      this.branchName,
      this.branchId,
      this.role,
      this.canAddAttendance,
      this.canAddPlan,
      this.shiftName,
      this.month,
      this.year,
      this.clockInTime,
      this.clockOutTime,
      this.area,
      this.id,
      this.userName,
      this.name,
      this.mobileId,
      this.deviceTokens,
      this.imageUrl});

  factory EmployeeData.fromJson(Map<String, dynamic> json) =>
      _$EmployeeDataFromJson(json);
}

typedef AllEmployeesResponse = AllEmployeesModel;
typedef EmployeesPage = GetAllEmployeesValue;
