// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_login_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleLoginRequestBody _$RoleLoginRequestBodyFromJson(
        Map<String, dynamic> json) =>
    RoleLoginRequestBody(
      email: json['userName'] as String,
      password: json['password'] as String,
      mobileId: json['mobileId'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$RoleLoginRequestBodyToJson(
        RoleLoginRequestBody instance) =>
    <String, dynamic>{
      'userName': instance.email,
      'password': instance.password,
      'mobileId': instance.mobileId,
      'role': instance.role,
    };
