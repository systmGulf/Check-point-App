import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_attendance_summary_request_body.g.dart';

@JsonSerializable()
class EmployeeAttendanceSummaryRequestBody {
  final String employeeId;
  final int month;
  final int year;

  const EmployeeAttendanceSummaryRequestBody({
    required this.employeeId,
    required this.month,
    required this.year,
  });

  factory EmployeeAttendanceSummaryRequestBody.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$EmployeeAttendanceSummaryRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$EmployeeAttendanceSummaryRequestBodyToJson(this);
}
