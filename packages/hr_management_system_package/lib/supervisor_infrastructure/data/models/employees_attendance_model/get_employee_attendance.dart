import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_employee_attendance.g.dart';

@JsonSerializable()
class SupervisorGetAllEmployeesAttendanceModel {
  @JsonKey(name: 'value')
  SupervisorGetAllEmployeesAttendanceValue? attendancePage;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  SupervisorGetAllEmployeesAttendanceModel({
    this.attendancePage,
    this.status,
    this.isSuccess,
    this.successMessage,
    this.correlationId,
    this.errors,
    this.validationErrors,
  });

  factory SupervisorGetAllEmployeesAttendanceModel.fromJson(
          Map<String, dynamic> json) =>
      _$SupervisorGetAllEmployeesAttendanceModelFromJson(json);

  @Deprecated('Use attendancePage instead.')
  SupervisorGetAllEmployeesAttendanceValue? get value => attendancePage;

  SupervisorGetAllEmployeesAttendanceValue get attendancePageOrEmpty =>
      attendancePage ?? SupervisorGetAllEmployeesAttendanceValue();
}
@JsonSerializable()
class SupervisorGetAllEmployeesAttendanceValue {
  List<SupervisorGetAllEmployeesAttendanceData>? data;
  int? totalCount;
  int? pageCount;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? start;
  int? end;

  SupervisorGetAllEmployeesAttendanceValue({
    this.data,
    this.totalCount,
    this.pageCount,
    this.hasNextPage,
    this.hasPreviousPage,
    this.start,
    this.end,
  });

  factory SupervisorGetAllEmployeesAttendanceValue.fromJson(
          Map<String, dynamic> json) =>
      _$SupervisorGetAllEmployeesAttendanceValueFromJson(json);
}

@JsonSerializable()
class SupervisorGetAllEmployeesAttendanceData {
  int? id;
  String? employeeName;
  String? attendanceDate;
  String? clockInTime;
  String? clockOutTime;
  String? dayHours;
  double? totalHours;
  String? location;
  String? area;
  String? employeeId;
  String? customerId;
  String? customerName;
  String? employeeImage;
  bool? isEarly;
  bool? isLate;
  List<CustomerPlan>? customerPlans;

  SupervisorGetAllEmployeesAttendanceData({
    this.id,
    this.employeeName,
    this.attendanceDate,
    this.clockInTime,
    this.clockOutTime,
    this.dayHours,
    this.totalHours,
    this.location,
    this.area,
    this.employeeId,
    this.customerId,
    this.customerName,
    this.employeeImage,
    this.isEarly,
    this.isLate,
    this.customerPlans,
  });

  factory SupervisorGetAllEmployeesAttendanceData.fromJson(
          Map<String, dynamic> json) =>
      _$SupervisorGetAllEmployeesAttendanceDataFromJson(json);
}
@JsonSerializable()
class CustomerPlan {
  int? id;
  String? note;
  List<CustomerPlanEmployee>? employees;
  CustomerInfo? customer;
  bool? visited;
  List<FeedbackModel>? feedbacks;

  CustomerPlan({
    this.id,
    this.note,
    this.employees,
    this.customer,
    this.visited,
    this.feedbacks,
  });

  factory CustomerPlan.fromJson(Map<String, dynamic> json) =>
      _$CustomerPlanFromJson(json);
}
@JsonSerializable()
class CustomerPlanEmployee {
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

  CustomerPlanEmployee({
    this.position,
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
    this.imageUrl,
  });

  factory CustomerPlanEmployee.fromJson(Map<String, dynamic> json) =>
      _$CustomerPlanEmployeeFromJson(json);
}
@JsonSerializable()
class CustomerInfo {
  String? id;
  String? name;
  String? workesAs;
  String? location;
  String? customerType;
  List<CustomerCoordinate>? coordinates;

  CustomerInfo({
    this.id,
    this.name,
    this.workesAs,
    this.location,
    this.customerType,
    this.coordinates,
  });

  factory CustomerInfo.fromJson(Map<String, dynamic> json) =>
      _$CustomerInfoFromJson(json);
}
@JsonSerializable()
class CustomerCoordinate {
  double? latitude;
  double? longitude;

  CustomerCoordinate({
    this.latitude,
    this.longitude,
  });

  factory CustomerCoordinate.fromJson(Map<String, dynamic> json) =>
      _$CustomerCoordinateFromJson(json);
}
@JsonSerializable()
class FeedbackModel {
  int? id;
  String? imageUrl;
  String? notes;
  String? status;

  FeedbackModel({
    this.id,
    this.imageUrl,
    this.notes,
    this.status,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackModelFromJson(json);
}

typedef SupervisorAttendanceResponse = SupervisorGetAllEmployeesAttendanceModel;
typedef SupervisorAttendancePage = SupervisorGetAllEmployeesAttendanceValue;
