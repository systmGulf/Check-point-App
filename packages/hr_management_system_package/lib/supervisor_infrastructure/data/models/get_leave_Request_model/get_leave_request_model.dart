import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_leave_request_model.g.dart';
@JsonSerializable()
class GetLeaveRequestModel {
  Value? value;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  GetLeaveRequestModel(
      {this.value,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});
  factory GetLeaveRequestModel.fromJson(Map<String, dynamic> json) => _$GetLeaveRequestModelFromJson(json);

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
  String? startDate;
  String? endDate;
  String? reason;
  String? remark;
  String? status;
  String? leaveRequestType;
  String? createdDate;
  String? createdBy;
  Employee? employee;

  Data(
      {this.id,
      this.startDate,
      this.endDate,
      this.reason,
      this.remark,
      this.status,
      this.leaveRequestType,
      this.createdDate,
      this.createdBy,
      this.employee});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
 
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
  String? imageUrl;
  

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
      this.deviceTokens, this.imageUrl});

  factory Employee.fromJson(Map<String, dynamic> json) => _$EmployeeFromJson(json);
} 