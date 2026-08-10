import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_customer_model.g.dart';
@JsonSerializable()
class CustomerModel {
  @JsonKey(name: 'value')
  CustomerValue? customersPage;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  CustomerModel(
      {this.customersPage,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});
factory CustomerModel.fromJson(Map<String, dynamic> json) => _$CustomerModelFromJson(json);

  @Deprecated('Use customersPage instead.')
  CustomerValue? get value => customersPage;

  CustomerValue get customersPageOrEmpty => customersPage ?? CustomerValue();
}
@JsonSerializable()

class CustomerValue {
  List<CustomerData>? data;
  int? totalCount;
  int? pageCount;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? start;
  int? end;

  CustomerValue(
      {this.data,
      this.totalCount,
      this.pageCount,
      this.hasNextPage,
      this.hasPreviousPage,
      this.start,
      this.end});

 factory CustomerValue.fromJson(Map<String, dynamic> json)  => _$CustomerValueFromJson(json);
}
@JsonSerializable()

class CustomerData {
  String? id;
  String? name;
  String? workesAs;
  String? location;
  String? customerType;
  List<CustomerCoordinates>? coordinates;

  CustomerData(
      {this.id,
      this.name,
      this.workesAs,
      this.location,
      this.customerType,
      this.coordinates});

  factory CustomerData.fromJson(Map<String, dynamic> json) => _$CustomerDataFromJson(json);
}
@JsonSerializable()

class CustomerCoordinates {
  double? latitude;
  double? longitude;

  CustomerCoordinates({this.latitude, this.longitude});

  factory CustomerCoordinates.fromJson(Map<String, dynamic> json) => _$CustomerCoordinatesFromJson(json);
  
}

typedef CustomersResponse = CustomerModel;
typedef CustomersPage = CustomerValue;
