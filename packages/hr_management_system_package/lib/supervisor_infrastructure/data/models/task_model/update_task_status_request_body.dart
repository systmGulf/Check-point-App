import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_task_status_request_body.g.dart';

@JsonSerializable()
class UpdateTaskStatusRequestBody {
  final int id;
  final String status;

  const UpdateTaskStatusRequestBody({
    required this.id,
    required this.status,
  });

  factory UpdateTaskStatusRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateTaskStatusRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateTaskStatusRequestBodyToJson(this);
}
