import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_account_request_body.g.dart';

@JsonSerializable()
class RegisterAccountRequestBody {
  final String name;
  final String mobileId;
  final String deviceToken;

  RegisterAccountRequestBody(
      {required this.name, required this.mobileId, required this.deviceToken});

  Map<String, dynamic> toJson() => _$RegisterAccountRequestBodyToJson(this);
}
