import 'package:freezed_annotation/freezed_annotation.dart';

part 'update_user_token_request_body.g.dart';

@JsonSerializable()
class UpdateUserTokenRequestBody {
  final String userId;
  final List<String> deviceTokens;

  const UpdateUserTokenRequestBody({
    required this.userId,
    required this.deviceTokens,
  });

  factory UpdateUserTokenRequestBody.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserTokenRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserTokenRequestBodyToJson(this);
}
