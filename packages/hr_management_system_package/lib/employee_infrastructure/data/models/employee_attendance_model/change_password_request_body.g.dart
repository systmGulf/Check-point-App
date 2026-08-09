// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChangePasswordRequestBody _$ChangePasswordRequestBodyFromJson(
        Map<String, dynamic> json) =>
    ChangePasswordRequestBody(
      oldPassword: json['currentPassword'] as String,
      newPassword: json['newPassword'] as String,
      employeeId: json['userId'] as String,
    );

Map<String, dynamic> _$ChangePasswordRequestBodyToJson(
        ChangePasswordRequestBody instance) =>
    <String, dynamic>{
      'userId': instance.employeeId,
      'currentPassword': instance.oldPassword,
      'newPassword': instance.newPassword,
    };
