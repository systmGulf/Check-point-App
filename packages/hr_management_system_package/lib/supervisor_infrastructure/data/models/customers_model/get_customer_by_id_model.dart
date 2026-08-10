
import 'package:freezed_annotation/freezed_annotation.dart';
part 'get_customer_by_id_model.g.dart';
@JsonSerializable()
class GetCustomerByIdModel {
  Value? value;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic  >? validationErrors;

  GetCustomerByIdModel(
      {this.value,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});

  factory GetCustomerByIdModel.fromJson(Map<String, dynamic> json) =>
      _$GetCustomerByIdModelFromJson(json);
}
@JsonSerializable()

class Value {
  String? id;
  String? name;
  String? workesAs;
  String? location;
  String? customerType;
  List<Coordinates>? coordinates;

  Value(
      {this.id,
      this.name,
      this.workesAs,
      this.location,
      this.customerType,
      this.coordinates});

factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);
}
@JsonSerializable()

class Coordinates {
  double? latitude;
  double? longitude;

  Coordinates({this.latitude, this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) => _$CoordinatesFromJson(json);
}
