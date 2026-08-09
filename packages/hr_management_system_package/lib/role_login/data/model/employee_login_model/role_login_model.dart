import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'role_login_model.g.dart';

@JsonSerializable()
class RoleLoginModel extends Equatable {
  final RoleLoginResponseValue? value;
  final int? status;
  final bool? isSuccess;
  final String? successMessage;
  final String? correlationId;
  final List<dynamic>? errors;
  final List<dynamic>? validationErrors;

  const RoleLoginModel({
    this.value,
    this.status,
    this.isSuccess,
    this.successMessage,
    this.correlationId,
    this.errors,
    this.validationErrors,
  });

  factory RoleLoginModel.fromJson(Map<String, dynamic> json) =>
      _$RoleLoginModelFromJson(json);

  Map<String, dynamic> toJson() => _$RoleLoginModelToJson(this);

  @override
  List<Object?> get props {
    return [
      value,
      status,
      isSuccess,
      successMessage,
      correlationId,
      errors,
      validationErrors,
    ];
  }
}

@JsonSerializable()
class RoleLoginResponseValue extends Equatable {
  final String? id;
  final String? userName;
  final String? name;
  final List<dynamic>? roles;
  final String? token;

  const RoleLoginResponseValue(
      {this.id, this.userName, this.name, this.roles, this.token});

  factory RoleLoginResponseValue.fromJson(Map<String, dynamic> json) =>
      _$RoleLoginResponseValueFromJson(json);
  Map<String, dynamic> toJson() => _$RoleLoginResponseValueToJson(this);
  @override
  List<Object?> get props => [id, userName, name, roles, token];
}
