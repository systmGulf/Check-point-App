import 'package:freezed_annotation/freezed_annotation.dart';
part 'shifts_model.g.dart';

@JsonSerializable()
class ShiftModel {
  ShiftValue? value;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  ShiftModel(
      {this.value,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});
  factory ShiftModel.fromJson(Map<String, dynamic> json) =>
      _$ShiftModelFromJson(json);
}

@JsonSerializable()
class ShiftValue {
  List<ShiftData>? data;
  int? totalCount;
  int? pageCount;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? start;
  int? end;

  ShiftValue(
      {this.data,
      this.totalCount,
      this.pageCount,
      this.hasNextPage,
      this.hasPreviousPage,
      this.start,
      this.end});
  factory ShiftValue.fromJson(Map<String, dynamic> json) =>
      _$ShiftValueFromJson(json);
}

@JsonSerializable()
class ShiftData {
  int? id;
  String? name;

  ShiftData({this.id, this.name});

  factory ShiftData.fromJson(Map<String, dynamic> json) =>
      _$ShiftDataFromJson(json);
}
