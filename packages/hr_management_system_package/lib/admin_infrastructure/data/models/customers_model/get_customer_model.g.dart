// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_customer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerModel _$CustomerModelFromJson(Map<String, dynamic> json) =>
    CustomerModel(
      customersPage: json['value'] == null
          ? null
          : CustomerValue.fromJson(json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$CustomerModelToJson(CustomerModel instance) =>
    <String, dynamic>{
      'value': instance.customersPage,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

CustomerValue _$CustomerValueFromJson(Map<String, dynamic> json) =>
    CustomerValue(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CustomerData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      pageCount: (json['pageCount'] as num?)?.toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
      start: (json['start'] as num?)?.toInt(),
      end: (json['end'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CustomerValueToJson(CustomerValue instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalCount': instance.totalCount,
      'pageCount': instance.pageCount,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'start': instance.start,
      'end': instance.end,
    };

CustomerData _$CustomerDataFromJson(Map<String, dynamic> json) => CustomerData(
      id: json['id'] as String?,
      name: json['name'] as String?,
      workesAs: json['workesAs'] as String?,
      location: json['location'] as String?,
      customerType: json['customerType'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => CustomerCoordinates.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerDataToJson(CustomerData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'workesAs': instance.workesAs,
      'location': instance.location,
      'customerType': instance.customerType,
      'coordinates': instance.coordinates,
    };

CustomerCoordinates _$CustomerCoordinatesFromJson(Map<String, dynamic> json) =>
    CustomerCoordinates(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CustomerCoordinatesToJson(
        CustomerCoordinates instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
