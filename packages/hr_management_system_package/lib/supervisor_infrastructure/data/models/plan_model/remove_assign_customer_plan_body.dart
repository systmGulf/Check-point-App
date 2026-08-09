import 'package:json_annotation/json_annotation.dart';

part 'remove_assign_customer_plan_body.g.dart';

@JsonSerializable()
class RemoveAssignCustomerPlanBody {
  final String employeeId;
  final int customerPlanId;

  const RemoveAssignCustomerPlanBody({
    required this.employeeId,
    required this.customerPlanId,
  });

  factory RemoveAssignCustomerPlanBody.fromJson(Map<String, dynamic> json) =>
      _$RemoveAssignCustomerPlanBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveAssignCustomerPlanBodyToJson(this);
}
