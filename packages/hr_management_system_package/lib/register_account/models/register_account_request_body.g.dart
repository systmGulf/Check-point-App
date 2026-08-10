// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_account_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterAccountRequestBody _$RegisterAccountRequestBodyFromJson(
        Map<String, dynamic> json) =>
    RegisterAccountRequestBody(
      name: json['name'] as String,
      mobileId: json['mobileId'] as String,
      deviceToken: json['deviceToken'] as String,
    );

Map<String, dynamic> _$RegisterAccountRequestBodyToJson(
        RegisterAccountRequestBody instance) =>
    <String, dynamic>{
      'name': instance.name,
      'mobileId': instance.mobileId,
      'deviceToken': instance.deviceToken,
    };
