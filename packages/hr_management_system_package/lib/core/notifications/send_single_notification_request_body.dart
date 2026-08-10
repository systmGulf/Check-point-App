import 'package:freezed_annotation/freezed_annotation.dart';

part 'send_single_notification_request_body.g.dart';

@JsonSerializable()
class SendSingleNotificationRequestBody {
  final String deviceToken;
  final String title;
  final String body;

  const SendSingleNotificationRequestBody({
    required this.deviceToken,
    required this.title,
    required this.body,
  });

  factory SendSingleNotificationRequestBody.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$SendSingleNotificationRequestBodyFromJson(json);

  Map<String, dynamic> toJson() =>
      _$SendSingleNotificationRequestBodyToJson(this);
}
