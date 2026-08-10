import 'package:freezed_annotation/freezed_annotation.dart';

part 'remove_employees_from_plan_request_body.g.dart';

@JsonSerializable()
class RemoveEmployeesFromPlanRequestBody {
  final String employeeIds;
  final int customerPlanId;

  const RemoveEmployeesFromPlanRequestBody({
    required this.employeeIds,
    required this.customerPlanId,
  });

  factory RemoveEmployeesFromPlanRequestBody.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$RemoveEmployeesFromPlanRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RemoveEmployeesFromPlanRequestBodyToJson(this);
}
