import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_multiple_notifications_request_body.g.dart';

@JsonSerializable()
class SendMultipleNotificationsRequestBody {
  final List<String> deviceTokens;
  final String title;
  final String body;
  final String topic;

  const SendMultipleNotificationsRequestBody({
    required this.deviceTokens,
    required this.title,
    required this.body,
    required this.topic,
  });

  factory SendMultipleNotificationsRequestBody.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SendMultipleNotificationsRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SendMultipleNotificationsRequestBodyToJson(this);
}
