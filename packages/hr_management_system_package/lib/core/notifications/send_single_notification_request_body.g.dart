// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_single_notification_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendSingleNotificationRequestBody _$SendSingleNotificationRequestBodyFromJson(
        Map<String, dynamic> json) =>
    SendSingleNotificationRequestBody(
      deviceToken: json['deviceToken'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$SendSingleNotificationRequestBodyToJson(
        SendSingleNotificationRequestBody instance) =>
    <String, dynamic>{
      'deviceToken': instance.deviceToken,
      'title': instance.title,
      'body': instance.body,
    };
