import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_summary_model.g.dart';
@JsonSerializable()
class EmployeeSummary {
  @JsonKey(name: 'value')
  EmployeeSummaryValue? summary;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  EmployeeSummary(
      {this.summary,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});
      factory EmployeeSummary.fromJson(Map<String, dynamic> json) => _$EmployeeSummaryFromJson(json);

  @Deprecated('Use summary instead.')
  EmployeeSummaryValue? get value => summary;

  EmployeeSummaryValue get summaryOrEmpty => summary ?? EmployeeSummaryValue();
}
@JsonSerializable()
class EmployeeSummaryValue {
  String? date;
  String? employeeId;
  String? employeeName;
  String? employeeImage;
  double? totalHoursWorked;
  int? totalDaysWorked;
  int? totalLateDays;
  int? totalEarlyLeaveDays;
  int? totalAbsentDays;

  EmployeeSummaryValue(
      {this.date,
      this.employeeId,
      this.employeeName,
      this.totalHoursWorked,
      this.totalDaysWorked,
      this.totalLateDays,
      this.employeeImage,
      this.totalEarlyLeaveDays,
      this.totalAbsentDays});
      factory EmployeeSummaryValue.fromJson(Map<String, dynamic> json) => _$EmployeeSummaryValueFromJson(json);


 
}

typedef EmployeeSummaryResponse = EmployeeSummary;
typedef AttendanceSummary = EmployeeSummaryValue;
