
import 'package:freezed_annotation/freezed_annotation.dart';

part  'employee_leave_requests.g.dart';
@JsonSerializable()
class EmployeeLeaveRequestsModel {
  @JsonKey(name: 'value')
  EmployeeLeaveRequestsValue? leaveRequestsPage;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  EmployeeLeaveRequestsModel(
      {this.leaveRequestsPage,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});

  factory EmployeeLeaveRequestsModel.fromJson(Map<String, dynamic> json) => _$EmployeeLeaveRequestsModelFromJson(json);

  @Deprecated('Use leaveRequestsPage instead.')
  EmployeeLeaveRequestsValue? get value => leaveRequestsPage;

  EmployeeLeaveRequestsValue get leaveRequestsPageOrEmpty =>
      leaveRequestsPage ?? EmployeeLeaveRequestsValue();
}
@JsonSerializable()

class EmployeeLeaveRequestsValue {
  List<EmployeeLeaveRequestsData>? data;
  int? totalCount;
  int? pageCount;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? start;
  int? end;

  EmployeeLeaveRequestsValue(
      {this.data,
      this.totalCount,
      this.pageCount,
      this.hasNextPage,
      this.hasPreviousPage,
      this.start,
      this.end});
factory  EmployeeLeaveRequestsValue.fromJson(Map<String, dynamic> json) => _$EmployeeLeaveRequestsValueFromJson(json);
}
@JsonSerializable()

class EmployeeLeaveRequestsData {
  int? id;
  String? startDate;
  String? endDate;
  String? reason;
  String? remark;
  String? status;
  String? leaveRequestType;
  String? employeeId;
  String? employeeName;
  String? createdDate;
  String? createdBy;

  EmployeeLeaveRequestsData(
      {this.id,
      this.startDate,
      this.endDate,
      this.reason,
      this.remark,
      this.status,
      this.leaveRequestType,
      this.employeeId,
      this.employeeName,
      this.createdDate,
      this.createdBy});
factory  EmployeeLeaveRequestsData.fromJson(Map<String, dynamic> json) => _$EmployeeLeaveRequestsDataFromJson(json);
}

typedef EmployeeLeaveRequestsResponse = EmployeeLeaveRequestsModel;
typedef LeaveRequestsPage = EmployeeLeaveRequestsValue;
