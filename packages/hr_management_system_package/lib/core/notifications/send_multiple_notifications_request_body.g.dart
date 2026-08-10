// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_multiple_notifications_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SendMultipleNotificationsRequestBody
    _$SendMultipleNotificationsRequestBodyFromJson(Map<String, dynamic> json) =>
        SendMultipleNotificationsRequestBody(
          deviceTokens: (json['deviceTokens'] as List<dynamic>)
              .map((e) => e as String)
              .toList(),
          title: json['title'] as String,
          body: json['body'] as String,
          topic: json['topic'] as String,
        );

Map<String, dynamic> _$SendMultipleNotificationsRequestBodyToJson(
        SendMultipleNotificationsRequestBody instance) =>
    <String, dynamic>{
      'deviceTokens': instance.deviceTokens,
      'title': instance.title,
      'body': instance.body,
      'topic': instance.topic,
    };
