// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_user_token_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateUserTokenRequestBody _$UpdateUserTokenRequestBodyFromJson(
        Map<String, dynamic> json) =>
    UpdateUserTokenRequestBody(
      userId: json['userId'] as String,
      deviceTokens: (json['deviceTokens'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$UpdateUserTokenRequestBodyToJson(
        UpdateUserTokenRequestBody instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'deviceTokens': instance.deviceTokens,
    };
