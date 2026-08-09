// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shifts_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftModel _$ShiftModelFromJson(Map<String, dynamic> json) => ShiftModel(
      value: json['value'] == null
          ? null
          : ShiftValue.fromJson(json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$ShiftModelToJson(ShiftModel instance) =>
    <String, dynamic>{
      'value': instance.value,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

ShiftValue _$ShiftValueFromJson(Map<String, dynamic> json) => ShiftValue(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ShiftData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      pageCount: (json['pageCount'] as num?)?.toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
      start: (json['start'] as num?)?.toInt(),
      end: (json['end'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ShiftValueToJson(ShiftValue instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalCount': instance.totalCount,
      'pageCount': instance.pageCount,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'start': instance.start,
      'end': instance.end,
    };

ShiftData _$ShiftDataFromJson(Map<String, dynamic> json) => ShiftData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ShiftDataToJson(ShiftData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
