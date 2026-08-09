// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_plan_by_id_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetPlanById _$GetPlanByIdFromJson(Map<String, dynamic> json) => GetPlanById(
      planDetails: json['value'] == null
          ? null
          : GetPlanByIdValue.fromJson(json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$GetPlanByIdToJson(GetPlanById instance) =>
    <String, dynamic>{
      'value': instance.planDetails,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

GetPlanByIdValue _$GetPlanByIdValueFromJson(Map<String, dynamic> json) =>
    GetPlanByIdValue(
      customerPlans: (json['customerPlans'] as List<dynamic>?)
          ?.map((e) => CustomerPlans.fromJson(e as Map<String, dynamic>))
          .toList(),
      id: (json['id'] as num?)?.toInt(),
      planDate: json['planDate'] as String?,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$GetPlanByIdValueToJson(GetPlanByIdValue instance) =>
    <String, dynamic>{
      'customerPlans': instance.customerPlans,
      'id': instance.id,
      'planDate': instance.planDate,
      'note': instance.note,
    };

CustomerPlans _$CustomerPlansFromJson(Map<String, dynamic> json) =>
    CustomerPlans(
      id: (json['id'] as num?)?.toInt(),
      note: json['note'] as String?,
      employees: (json['employees'] as List<dynamic>?)
          ?.map((e) => Employees.fromJson(e as Map<String, dynamic>))
          .toList(),
      customer: json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
      visited: json['visited'] as bool?,
    );

Map<String, dynamic> _$CustomerPlansToJson(CustomerPlans instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'employees': instance.employees,
      'customer': instance.customer,
      'visited': instance.visited,
    };

Employees _$EmployeesFromJson(Map<String, dynamic> json) => Employees(
      position: json['position'] as String?,
      departmentName: json['departmentName'] as String?,
      departmentId: (json['departmentId'] as num?)?.toInt(),
      branchName: json['branchName'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      role: json['role'] as String?,
      canAddAttendance: json['canAddAttendance'] as bool?,
      canAddPlan: json['canAddPlan'] as bool?,
      id: json['id'] as String?,
      userName: json['userName'] as String?,
      name: json['name'] as String?,
      mobileId: json['mobileId'] as String?,
      deviceTokens: (json['deviceTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$EmployeesToJson(Employees instance) => <String, dynamic>{
      'position': instance.position,
      'departmentName': instance.departmentName,
      'departmentId': instance.departmentId,
      'branchName': instance.branchName,
      'branchId': instance.branchId,
      'role': instance.role,
      'canAddAttendance': instance.canAddAttendance,
      'canAddPlan': instance.canAddPlan,
      'id': instance.id,
      'userName': instance.userName,
      'name': instance.name,
      'mobileId': instance.mobileId,
      'deviceTokens': instance.deviceTokens,
      'imageUrl': instance.imageUrl,
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
