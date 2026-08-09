// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_branches_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetBranchesModel _$GetBranchesModelFromJson(Map<String, dynamic> json) =>
    GetBranchesModel(
      branchesPage: json['value'] == null
          ? null
          : GetBranchesValue.fromJson(json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$GetBranchesModelToJson(GetBranchesModel instance) =>
    <String, dynamic>{
      'value': instance.branchesPage,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

GetBranchesValue _$GetBranchesValueFromJson(Map<String, dynamic> json) =>
    GetBranchesValue(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => GetBranchesData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      pageCount: (json['pageCount'] as num?)?.toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
      start: (json['start'] as num?)?.toInt(),
      end: (json['end'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GetBranchesValueToJson(GetBranchesValue instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalCount': instance.totalCount,
      'pageCount': instance.pageCount,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'start': instance.start,
      'end': instance.end,
    };

GetBranchesData _$GetBranchesDataFromJson(Map<String, dynamic> json) =>
    GetBranchesData(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      location: json['location'] as String?,
      description: json['description'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map(
              (e) => GetBranchesCoordinates.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetBranchesDataToJson(GetBranchesData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'location': instance.location,
      'description': instance.description,
      'coordinates': instance.coordinates,
    };

GetBranchesCoordinates _$GetBranchesCoordinatesFromJson(
        Map<String, dynamic> json) =>
    GetBranchesCoordinates(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$GetBranchesCoordinatesToJson(
        GetBranchesCoordinates instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
