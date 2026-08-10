// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_customer_by_id_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetCustomerByIdModel _$GetCustomerByIdModelFromJson(
        Map<String, dynamic> json) =>
    GetCustomerByIdModel(
      value: json['value'] == null
          ? null
          : Value.fromJson(json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$GetCustomerByIdModelToJson(
        GetCustomerByIdModel instance) =>
    <String, dynamic>{
      'value': instance.value,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

Value _$ValueFromJson(Map<String, dynamic> json) => Value(
      id: json['id'] as String?,
      name: json['name'] as String?,
      workesAs: json['workesAs'] as String?,
      location: json['location'] as String?,
      customerType: json['customerType'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => Coordinates.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'workesAs': instance.workesAs,
      'location': instance.location,
      'customerType': instance.customerType,
      'coordinates': instance.coordinates,
    };

Coordinates _$CoordinatesFromJson(Map<String, dynamic> json) => Coordinates(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CoordinatesToJson(Coordinates instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
