// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remove_assign_task_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoveAssignTaskRequestBody _$RemoveAssignTaskRequestBodyFromJson(
        Map<String, dynamic> json) =>
    RemoveAssignTaskRequestBody(
      employeeId: json['employeeId'] as String,
      taskId: (json['taskId'] as num).toInt(),
    );

Map<String, dynamic> _$RemoveAssignTaskRequestBodyToJson(
        RemoveAssignTaskRequestBody instance) =>
    <String, dynamic>{
      'employeeId': instance.employeeId,
      'taskId': instance.taskId,
    };
