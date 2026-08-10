import 'package:freezed_annotation/freezed_annotation.dart';
part 'leave_request_request_body.g.dart';

@JsonSerializable()
class LeaveRequestRequestBody {
  final String employeeId;
  final String startDate;
  final String endDate;
  final String reason;
  final String remark;
  final String leaveRequestType;

  LeaveRequestRequestBody(
      {required this.employeeId,
      required this.startDate,
      required this.leaveRequestType,
      required this.endDate,
      required this.reason,
      required this.remark});

  Map<String, dynamic> toJson() => _$LeaveRequestRequestBodyToJson(this);
}
