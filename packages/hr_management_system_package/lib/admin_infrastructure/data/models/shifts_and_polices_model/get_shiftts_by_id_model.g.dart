// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_shiftts_by_id_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetShiftByIdModel _$GetShiftByIdModelFromJson(Map<String, dynamic> json) =>
    GetShiftByIdModel(
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

Map<String, dynamic> _$GetShiftByIdModelToJson(GetShiftByIdModel instance) =>
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
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };
