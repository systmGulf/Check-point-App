import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_customer_request_body.g.dart';

@JsonSerializable(explicitToJson: true)
class AddOrEditCustomerRequestBody {
  final String name;
  final String workesAs;
  final String location;
  final String customerType;
  final List<CustomerLocation> coordinates;

  AddOrEditCustomerRequestBody({
    required this.name,
    required this.workesAs,
    required this.location,
    required this.coordinates,
    required this.customerType,
  });

  Map<String, dynamic> toJson() => _$AddOrEditCustomerRequestBodyToJson(this);
}

@JsonSerializable()
class CustomerLocation {
  final double latitude;
  final double longitude;
  CustomerLocation({required this.latitude, required this.longitude});

  factory CustomerLocation.fromJson(Map<String, dynamic> json) =>
      _$CustomerLocationFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerLocationToJson(this);
}
