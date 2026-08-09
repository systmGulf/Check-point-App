
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_task_request_body.g.dart';
@JsonSerializable()
class AddTaskRequestBody {
  final String title;
  final String description;
  final String dueDate;
  final String priorityStatus;
  final String status;

  AddTaskRequestBody({required this.title, required this.description, required this.dueDate, required this.priorityStatus, required this.status});
    Map<String, dynamic> toJson() => _$AddTaskRequestBodyToJson(this);
}