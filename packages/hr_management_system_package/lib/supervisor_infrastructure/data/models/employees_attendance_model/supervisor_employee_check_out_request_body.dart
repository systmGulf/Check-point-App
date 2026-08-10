import 'package:freezed_annotation/freezed_annotation.dart';

part 'supervisor_employee_check_out_request_body.g.dart';

@JsonSerializable()
class SupervisorEmployeeCheckOutRequestBody {
  final String employeeId;
  final String? employeeImage;

  const SupervisorEmployeeCheckOutRequestBody({
    required this.employeeId,
    required this.employeeImage,
  });

  factory SupervisorEmployeeCheckOutRequestBody.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SupervisorEmployeeCheckOutRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SupervisorEmployeeCheckOutRequestBodyToJson(this);
}
