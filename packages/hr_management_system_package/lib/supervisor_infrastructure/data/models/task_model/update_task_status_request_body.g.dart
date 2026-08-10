// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_task_status_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTaskStatusRequestBody _$UpdateTaskStatusRequestBodyFromJson(
        Map<String, dynamic> json) =>
    UpdateTaskStatusRequestBody(
      id: (json['id'] as num).toInt(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$UpdateTaskStatusRequestBodyToJson(
        UpdateTaskStatusRequestBody instance) =>
    <String, dynamic>{
      'id': instance.id,
      'status': instance.status,
    };
