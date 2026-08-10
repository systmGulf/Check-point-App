// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_login_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoleLoginModel _$RoleLoginModelFromJson(Map<String, dynamic> json) =>
    RoleLoginModel(
      value: json['value'] == null
          ? null
          : RoleLoginResponseValue.fromJson(
              json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$RoleLoginModelToJson(RoleLoginModel instance) =>
    <String, dynamic>{
      'value': instance.value,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

RoleLoginResponseValue _$RoleLoginResponseValueFromJson(
        Map<String, dynamic> json) =>
    RoleLoginResponseValue(
      id: json['id'] as String?,
      userName: json['userName'] as String?,
      name: json['name'] as String?,
      roles: json['roles'] as List<dynamic>?,
      token: json['token'] as String?,
    );

Map<String, dynamic> _$RoleLoginResponseValueToJson(
        RoleLoginResponseValue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.userName,
      'name': instance.name,
      'roles': instance.roles,
      'token': instance.token,
    };
