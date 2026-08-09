// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_customer_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddOrEditCustomerRequestBody _$AddOrEditCustomerRequestBodyFromJson(
        Map<String, dynamic> json) =>
    AddOrEditCustomerRequestBody(
      name: json['name'] as String,
      workesAs: json['workesAs'] as String,
      location: json['location'] as String,
      coordinates: (json['coordinates'] as List<dynamic>)
          .map((e) => CustomerLocation.fromJson(e as Map<String, dynamic>))
          .toList(),
      customerType: json['customerType'] as String,
    );

Map<String, dynamic> _$AddOrEditCustomerRequestBodyToJson(
        AddOrEditCustomerRequestBody instance) =>
    <String, dynamic>{
      'name': instance.name,
      'workesAs': instance.workesAs,
      'location': instance.location,
      'customerType': instance.customerType,
      'coordinates': instance.coordinates.map((e) => e.toJson()).toList(),
    };

CustomerLocation _$CustomerLocationFromJson(Map<String, dynamic> json) =>
    CustomerLocation(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$CustomerLocationToJson(CustomerLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
