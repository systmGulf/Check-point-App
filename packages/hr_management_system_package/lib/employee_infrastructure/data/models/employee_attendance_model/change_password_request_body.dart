import 'package:freezed_annotation/freezed_annotation.dart';

part 'change_password_request_body.g.dart';

@JsonSerializable()
class ChangePasswordRequestBody {
  @JsonKey(name: 'userId')
  final String employeeId;
  @JsonKey(name: 'currentPassword')
  final String oldPassword;
  final String newPassword;

  ChangePasswordRequestBody(
      {required this.oldPassword,
      required this.newPassword,
      required this.employeeId});

  Map<String, dynamic> toJson() => _$ChangePasswordRequestBodyToJson(this);
}
