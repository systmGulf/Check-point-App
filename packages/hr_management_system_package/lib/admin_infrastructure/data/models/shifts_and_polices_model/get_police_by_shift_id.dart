import 'package:json_annotation/json_annotation.dart';

part 'get_police_by_shift_id.g.dart';

@JsonSerializable()
class PoliceResponse {
  Value? value;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  PoliceResponse({
    this.value,
    this.status,
    this.isSuccess,
    this.successMessage,
    this.correlationId,
    this.errors,
    this.validationErrors,
  });

  factory PoliceResponse.fromJson(Map<String, dynamic> json) =>
      _$PoliceResponseFromJson(json);

  Map<String, dynamic> toJson() => _$PoliceResponseToJson(this);
}

@JsonSerializable()
class Value {
  List<Data>? data;
  int? totalCount;
  int? pageCount;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? start;
  int? end;

  Value({
    this.data,
    this.totalCount,
    this.pageCount,
    this.hasNextPage,
    this.hasPreviousPage,
    this.start,
    this.end,
  });

  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);

  Map<String, dynamic> toJson() => _$ValueToJson(this);
}

@JsonSerializable()
class Data {
  int? id;
  int? month;
  int? year;
  String? clockInTime;
  String? clockOutTime;
  String? area;
  Shift? shift;
  List<Employee>? employees;

  Data({
    this.id,
    this.month,
    this.year,
    this.clockInTime,
    this.clockOutTime,
    this.area,
    this.shift,
    this.employees,
  });

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

  Map<String, dynamic> toJson() => _$DataToJson(this);
}

@JsonSerializable()
class Shift {
  int? id;
  String? name;

  Shift({
    this.id,
    this.name,
  });

  factory Shift.fromJson(Map<String, dynamic> json) => _$ShiftFromJson(json);

  Map<String, dynamic> toJson() => _$ShiftToJson(this);
}

@JsonSerializable()
class Employee {
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

  Employee({
    this.position,
    this.departmentName,
    this.branchName,
    this.branchId,
    this.role,
    this.name,
    this.imageUrl,
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
    this.mobileId,
    this.deviceTokens,
  });

  factory Employee.fromJson(Map<String, dynamic> json) =>
      _$EmployeeFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeToJson(this);
}
