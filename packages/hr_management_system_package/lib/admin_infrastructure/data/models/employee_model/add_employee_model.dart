import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_employee_model.g.dart';

@JsonSerializable()
class AddEmployeeModel extends Equatable {
  final dynamic value;
  final int? status;
  final bool? isSuccess;
  final String? successMessage;
  final String? correlationId;
  final List<dynamic>? errors;
  final List<dynamic>? validationErrors;

  const AddEmployeeModel({
    this.value,
    this.status,
    this.isSuccess,
    this.successMessage,
    this.correlationId,
    this.errors,
    this.validationErrors,
  });

  factory AddEmployeeModel.fromJson(Map<String, dynamic> json) =>
      _$AddEmployeeModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddEmployeeModelToJson(this);
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
