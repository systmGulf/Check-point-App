// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assign_task_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AssignTaskRequestBody _$AssignTaskRequestBodyFromJson(
        Map<String, dynamic> json) =>
    AssignTaskRequestBody(
      employeeIds: (json['employeeIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      taskId: (json['taskId'] as num).toInt(),
    );

Map<String, dynamic> _$AssignTaskRequestBodyToJson(
        AssignTaskRequestBody instance) =>
    <String, dynamic>{
      'employeeIds': instance.employeeIds,
      'taskId': instance.taskId,
    };
