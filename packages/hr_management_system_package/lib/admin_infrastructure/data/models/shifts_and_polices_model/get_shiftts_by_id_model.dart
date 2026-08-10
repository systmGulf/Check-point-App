import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_shiftts_by_id_model.g.dart';

@JsonSerializable()
class GetShiftByIdModel {
  Value? value;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  GetShiftByIdModel(
      {this.value,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});
  factory GetShiftByIdModel.fromJson(Map<String, dynamic> json) =>
      _$GetShiftByIdModelFromJson(json);
}

@JsonSerializable()
class Value {
  int? id;
  String? name;

  Value({this.id, this.name});

  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);
}
