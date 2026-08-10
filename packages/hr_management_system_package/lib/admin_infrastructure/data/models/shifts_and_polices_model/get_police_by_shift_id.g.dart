// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_police_by_shift_id.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PoliceResponse _$PoliceResponseFromJson(Map<String, dynamic> json) =>
    PoliceResponse(
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

Map<String, dynamic> _$PoliceResponseToJson(PoliceResponse instance) =>
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
      month: (json['month'] as num?)?.toInt(),
      year: (json['year'] as num?)?.toInt(),
      clockInTime: json['clockInTime'] as String?,
      clockOutTime: json['clockOutTime'] as String?,
      area: json['area'] as String?,
      shift: json['shift'] == null
          ? null
          : Shift.fromJson(json['shift'] as Map<String, dynamic>),
      employees: (json['employees'] as List<dynamic>?)
          ?.map((e) => Employee.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DataToJson(Data instance) => <String, dynamic>{
      'id': instance.id,
      'month': instance.month,
      'year': instance.year,
      'clockInTime': instance.clockInTime,
      'clockOutTime': instance.clockOutTime,
      'area': instance.area,
      'shift': instance.shift,
      'employees': instance.employees,
    };

Shift _$ShiftFromJson(Map<String, dynamic> json) => Shift(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ShiftToJson(Shift instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
    };

Employee _$EmployeeFromJson(Map<String, dynamic> json) => Employee(
      position: json['position'] as String?,
      departmentName: json['departmentName'] as String?,
      branchName: json['branchName'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      role: json['role'] as String?,
      name: json['name'] as String?,
      imageUrl: json['imageUrl'] as String?,
      canAddAttendance: json['canAddAttendance'] as bool?,
      canAddPlan: json['canAddPlan'] as bool?,
      shiftName: json['shiftName'] as String?,
      month: (json['month'] as num?)?.toInt(),
      year: (json['year'] as num?)?.toInt(),
      clockInTime: json['clockInTime'] as String?,
      clockOutTime: json['clockOutTime'] as String?,
      area: json['area'] as String?,
      id: json['id'] as String?,
      userName: json['userName'] as String?,
      mobileId: json['mobileId'] as String?,
      deviceTokens: (json['deviceTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    )..departmentId = (json['departmentId'] as num?)?.toInt();

Map<String, dynamic> _$EmployeeToJson(Employee instance) => <String, dynamic>{
      'position': instance.position,
      'departmentName': instance.departmentName,
      'departmentId': instance.departmentId,
      'branchName': instance.branchName,
      'branchId': instance.branchId,
      'role': instance.role,
      'canAddAttendance': instance.canAddAttendance,
      'canAddPlan': instance.canAddPlan,
      'shiftName': instance.shiftName,
      'month': instance.month,
      'year': instance.year,
      'clockInTime': instance.clockInTime,
      'clockOutTime': instance.clockOutTime,
      'area': instance.area,
      'id': instance.id,
      'userName': instance.userName,
      'name': instance.name,
      'mobileId': instance.mobileId,
      'deviceTokens': instance.deviceTokens,
      'imageUrl': instance.imageUrl,
    };
