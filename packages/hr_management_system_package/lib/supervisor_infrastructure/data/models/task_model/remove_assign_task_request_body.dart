import 'package:freezed_annotation/freezed_annotation.dart';

part 'remove_assign_task_request_body.g.dart';

@JsonSerializable()
class RemoveAssignTaskRequestBody {
  final String employeeId;
  final int taskId;

  const RemoveAssignTaskRequestBody({
    required this.employeeId,
    required this.taskId,
  });

  factory RemoveAssignTaskRequestBody.fromJson(Map<String, dynamic> json) =>
      _$RemoveAssignTaskRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$RemoveAssignTaskRequestBodyToJson(this);
}
