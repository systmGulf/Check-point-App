// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_plan_by_employee_id_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmployeePlansModel _$EmployeePlansModelFromJson(Map<String, dynamic> json) =>
    EmployeePlansModel(
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

Map<String, dynamic> _$EmployeePlansModelToJson(EmployeePlansModel instance) =>
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
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Data.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      pageCount: (json['pageCount'] as num?)?.toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
      start: (json['start'] as num?)?.toInt(),
      end: (json['end'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ValueToJson(Value instance) => <String, dynamic>{
      'data': instance.data,
      'totalCount': instance.totalCount,
      'pageCount': instance.pageCount,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'start': instance.start,
      'end': instance.end,
    };

Data _$DataFromJson(Map<String, dynamic> json) => Data(
      id: (json['id'] as num?)?.toInt(),
      note: json['note'] as String?,
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      plan: json['plan'] == null
          ? null
          : Plan.fromJson(json['plan'] as Map<String, dynamic>),
      visited: json['visited'] as bool?,
      feedbacks: (json['feedbacks'] as List<dynamic>?)
          ?.map((e) => FeedbackModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdDate: json['createdDate'] as String?,
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'customer': instance.customer,
      'plan': instance.plan,
      'visited': instance.visited,
      'feedbacks': instance.feedbacks,
      'createdDate': instance.createdDate,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as String?,
      name: json['name'] as String?,
      workesAs: json['workesAs'] as String?,
      location: json['location'] as String?,
      customerType: json['customerType'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => Coordinates.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
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

Plan _$PlanFromJson(Map<String, dynamic> json) => Plan(
      id: (json['id'] as num?)?.toInt(),
      planDate: json['planDate'] == null
          ? null
          : DateTime.parse(json['planDate'] as String),
      note: json['note'] as String?,
      departmentName: json['departmentName'] as String?,
    );

Map<String, dynamic> _$PlanToJson(Plan instance) => <String, dynamic>{
      'id': instance.id,
      'planDate': instance.planDate?.toIso8601String(),
      'note': instance.note,
      'departmentName': instance.departmentName,
    };

FeedbackModel _$FeedbackModelFromJson(Map<String, dynamic> json) =>
    FeedbackModel(
      id: (json['id'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] as String?,
      notes: json['notes'] as String?,
      status: json['status'] as String?,
    );

Map<String, dynamic> _$FeedbackModelToJson(FeedbackModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'notes': instance.notes,
      'status': instance.status,
    };
