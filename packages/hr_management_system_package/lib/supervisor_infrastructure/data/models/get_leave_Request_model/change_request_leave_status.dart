import 'package:json_annotation/json_annotation.dart';

part 'change_request_leave_status.g.dart';

@JsonSerializable()
class ChangeRequestLeaveStatus {
  final int leaveRequestId;
  final String status;

  ChangeRequestLeaveStatus({
    required this.leaveRequestId,
    required this.status,
  });

  factory ChangeRequestLeaveStatus.fromJson(Map<String, dynamic> json) =>
      _$ChangeRequestLeaveStatusFromJson(json);

  Map<String, dynamic> toJson() => _$ChangeRequestLeaveStatusToJson(this);
}
