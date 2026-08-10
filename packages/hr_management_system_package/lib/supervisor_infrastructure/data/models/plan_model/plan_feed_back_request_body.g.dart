// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_feed_back_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlanFeedBackRequestBody _$PlanFeedBackRequestBodyFromJson(
        Map<String, dynamic> json) =>
    PlanFeedBackRequestBody(
      imageUrl: json['imageUrl'] as String,
      notes: json['notes'] as String,
      status: json['status'] as String,
      customerPlanId: (json['customerPlanId'] as num).toInt(),
    );

Map<String, dynamic> _$PlanFeedBackRequestBodyToJson(
        PlanFeedBackRequestBody instance) =>
    <String, dynamic>{
      'imageUrl': instance.imageUrl,
      'notes': instance.notes,
      'status': instance.status,
      'customerPlanId': instance.customerPlanId,
    };
