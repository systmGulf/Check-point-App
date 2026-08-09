// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_account_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddAccountRequestModel _$AddAccountRequestModelFromJson(
        Map<String, dynamic> json) =>
    AddAccountRequestModel(
      accountRequestsPage: json['value'] == null
          ? null
          : AddAccountRequestValue.fromJson(
              json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$AddAccountRequestModelToJson(
        AddAccountRequestModel instance) =>
    <String, dynamic>{
      'value': instance.accountRequestsPage,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

AddAccountRequestValue _$AddAccountRequestValueFromJson(
        Map<String, dynamic> json) =>
    AddAccountRequestValue(
      data: (json['data'] as List<dynamic>?)
          ?.map(
              (e) => AddAccountRequestData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      pageCount: (json['pageCount'] as num?)?.toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
      start: (json['start'] as num?)?.toInt(),
      end: (json['end'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AddAccountRequestValueToJson(
        AddAccountRequestValue instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalCount': instance.totalCount,
      'pageCount': instance.pageCount,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'start': instance.start,
      'end': instance.end,
    };

AddAccountRequestData _$AddAccountRequestDataFromJson(
        Map<String, dynamic> json) =>
    AddAccountRequestData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      mobileId: json['mobileId'] as String?,
      deviceToken: json['deviceToken'] as String?,
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
    );

Map<String, dynamic> _$AddAccountRequestDataToJson(
        AddAccountRequestData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mobileId': instance.mobileId,
      'deviceToken': instance.deviceToken,
      'createdDate': instance.createdDate?.toIso8601String(),
    };
