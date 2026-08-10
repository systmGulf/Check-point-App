import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_check_out_request_body.g.dart';

@JsonSerializable()
class EmployeeCheckOutRequestBody {
  final String employeeId;
  final String? employeeImage;

  const EmployeeCheckOutRequestBody({
    required this.employeeId,
    required this.employeeImage,
  });

  factory EmployeeCheckOutRequestBody.fromJson(Map<String, dynamic> json) =>
      _$EmployeeCheckOutRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeeCheckOutRequestBodyToJson(this);
}
