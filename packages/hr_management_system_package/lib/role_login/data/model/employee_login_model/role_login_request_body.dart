import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_login_request_body.g.dart';

@JsonSerializable()
class RoleLoginRequestBody {
  @JsonKey(name: 'userName')
  final String email;
  final String password;
  final String mobileId;
  final String role;

  RoleLoginRequestBody(
      {required this.email,
      required this.password,
      required this.mobileId,
      required this.role});

  Map<String, dynamic> toJson() => _$RoleLoginRequestBodyToJson(this);
}
