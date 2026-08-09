// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_plan_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomerPlanModel _$CustomerPlanModelFromJson(Map<String, dynamic> json) =>
    CustomerPlanModel(
      value: (json['value'] as List<dynamic>?)
          ?.map((e) => CustomerPlanValue.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$CustomerPlanModelToJson(CustomerPlanModel instance) =>
    <String, dynamic>{
      'value': instance.value,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

CustomerPlanValue _$CustomerPlanValueFromJson(Map<String, dynamic> json) =>
    CustomerPlanValue(
      id: (json['id'] as num?)?.toInt(),
      planDate: json['planDate'] as String?,
      note: json['note'] as String?,
      employees: (json['employees'] as List<dynamic>?)
          ?.map((e) => Employees.fromJson(e as Map<String, dynamic>))
          .toList(),
      customers: (json['customers'] as List<dynamic>?)
          ?.map((e) => Customer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerPlanValueToJson(CustomerPlanValue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'planDate': instance.planDate,
      'note': instance.note,
      'employees': instance.employees,
      'customers': instance.customers,
    };

Employees _$EmployeesFromJson(Map<String, dynamic> json) => Employees(
      position: json['position'] as String?,
      departmentName: json['departmentName'] as String?,
      departmentId: (json['departmentId'] as num?)?.toInt(),
      branchName: json['branchName'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      role: json['role'] as String?,
      id: json['id'] as String?,
      userName: json['userName'] as String?,
      name: json['name'] as String?,
      mobileId: json['mobileId'] as String?,
    );

Map<String, dynamic> _$EmployeesToJson(Employees instance) => <String, dynamic>{
      'position': instance.position,
      'departmentName': instance.departmentName,
      'departmentId': instance.departmentId,
      'branchName': instance.branchName,
      'branchId': instance.branchId,
      'role': instance.role,
      'id': instance.id,
      'userName': instance.userName,
      'name': instance.name,
      'mobileId': instance.mobileId,
    };

Customer _$CustomerFromJson(Map<String, dynamic> json) => Customer(
      id: json['id'] as String?,
      name: json['name'] as String?,
      workesAs: json['workesAs'] as String?,
      location: json['location'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => Coordinates.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'workesAs': instance.workesAs,
      'location': instance.location,
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
