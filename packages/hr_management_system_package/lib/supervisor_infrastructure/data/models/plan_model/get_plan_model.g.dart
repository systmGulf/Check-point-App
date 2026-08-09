// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanModel _$PlanModelFromJson(Map<String, dynamic> json) => PlanModel(
      plansPage: json['value'] == null
          ? null
          : PlanValue.fromJson(json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$PlanModelToJson(PlanModel instance) => <String, dynamic>{
      'value': instance.plansPage,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

PlanValue _$PlanValueFromJson(Map<String, dynamic> json) => PlanValue(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => PlanData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      pageCount: (json['pageCount'] as num?)?.toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
      start: (json['start'] as num?)?.toInt(),
      end: (json['end'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PlanValueToJson(PlanValue instance) => <String, dynamic>{
      'data': instance.data,
      'totalCount': instance.totalCount,
      'pageCount': instance.pageCount,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'start': instance.start,
      'end': instance.end,
    };

PlanData _$PlanDataFromJson(Map<String, dynamic> json) => PlanData(
      id: (json['id'] as num?)?.toInt(),
      planDate: json['planDate'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$PlanDataToJson(PlanData instance) => <String, dynamic>{
      'id': instance.id,
      'planDate': instance.planDate,
      'note': instance.note,
    };
