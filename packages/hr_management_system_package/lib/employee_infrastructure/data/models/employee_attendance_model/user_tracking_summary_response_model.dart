
import 'package:freezed_annotation/freezed_annotation.dart';
part 'user_tracking_summary_response_model.g.dart';
@JsonSerializable()
class UserTrackingSummaryResponseBody {
  Value? value;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  UserTrackingSummaryResponseBody(
      {this.value,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});
  factory UserTrackingSummaryResponseBody.fromJson(Map<String, dynamic> json) => _$UserTrackingSummaryResponseBodyFromJson(json);
 
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

  Value(
      {this.data,
      this.totalCount,
      this.pageCount,
      this.hasNextPage,
      this.hasPreviousPage,
      this.start,
      this.end});
  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);

}
@JsonSerializable()
class Data {
  int? id;
  List<Coordinates>? coordinates;
  Employee? employee;

  Data({this.id, this.coordinates, this.employee});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
}
@JsonSerializable()
class Coordinates {
  double? latitude;
  double? longitude;

  Coordinates({this.latitude, this.longitude});

 factory Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);
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
  String? id;
  String? userName;
  String? name;
  String? mobileId;
  List<String>? deviceTokens;

  Employee(
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
      this.deviceTokens});

 factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);
}