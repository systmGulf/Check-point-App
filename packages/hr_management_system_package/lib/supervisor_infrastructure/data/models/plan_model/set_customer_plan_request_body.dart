import 'package:freezed_annotation/freezed_annotation.dart';

part 'set_customer_plan_request_body.g.dart';

@JsonSerializable()
class SetCustomerPlanRequestBody {
  final String planDate;
  final String note;
  final List<String> employeeIds;
  final String customerId;

  SetCustomerPlanRequestBody(
      {required this.planDate,
      required this.note,
      required this.employeeIds,
      required this.customerId});

  Map<String, dynamic> toJson() => _$SetCustomerPlanRequestBodyToJson(this);
}

@JsonSerializable()
class SetPlanByDateRequestBody {
  final String planDate;
  final String note;
  final String departmentId;

  SetPlanByDateRequestBody(
      {required this.planDate, required this.note, required this.departmentId});

  Map<String, dynamic> toJson() => _$SetPlanByDateRequestBodyToJson(this);
}

@JsonSerializable()
class SetSubPlansRequestBody {
  final String note;
  final List<String> employeeIds;
  @JsonKey(name: "customerId")
  final String customerIdOrSiteId;
  final int planId;

  SetSubPlansRequestBody({
    required this.note,
    required this.employeeIds,
    required this.customerIdOrSiteId,
    required this.planId,
  });

  Map<String, dynamic> toJson() => _$SetSubPlansRequestBodyToJson(this);
}
