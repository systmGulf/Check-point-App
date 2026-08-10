import 'package:freezed_annotation/freezed_annotation.dart';

part 'assign_task_request_body.g.dart';

@JsonSerializable()
class AssignTaskRequestBody {
  final List<String> employeeIds;
  final int taskId;

  const AssignTaskRequestBody({
    required this.employeeIds,
    required this.taskId,
  });

  factory AssignTaskRequestBody.fromJson(Map<String, dynamic> json) =>
      _$AssignTaskRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$AssignTaskRequestBodyToJson(this);
}
