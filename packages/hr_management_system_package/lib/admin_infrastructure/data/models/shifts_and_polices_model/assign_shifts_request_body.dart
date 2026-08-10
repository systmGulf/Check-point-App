
 import 'package:freezed_annotation/freezed_annotation.dart';
part 'assign_shifts_request_body.g.dart';
@JsonSerializable()
class AssignShiftsRequestBody {
  final int shiftId;
  final List<int> branchesIds;

  AssignShiftsRequestBody({required this.shiftId, required this.branchesIds});
  Map<String, dynamic> toJson() => _$AssignShiftsRequestBodyToJson(this);
}
@JsonSerializable()
class AssignPoliceRequestBody {
  final int policyId;
  final List<String> employeeIds;

  AssignPoliceRequestBody({required this.policyId, required this.employeeIds});
  Map<String, dynamic> toJson() => _$AssignPoliceRequestBodyToJson(this);
}


@JsonSerializable()
class RemoveAssignPolicyRequestBody {
  final String employeeId;
  final int policyId;

  RemoveAssignPolicyRequestBody({required this.employeeId, required this.policyId});
  Map<String, dynamic> toJson() => _$RemoveAssignPolicyRequestBodyToJson(this);
}
