// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_attendace_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserAttendanceModel _$UserAttendanceModelFromJson(Map<String, dynamic> json) =>
    UserAttendanceModel(
      attendancePage: json['value'] == null
          ? null
          : UserAttendanceValue.fromJson(json['value'] as Map<String, dynamic>),
      status: (json['status'] as num?)?.toInt(),
      isSuccess: json['isSuccess'] as bool?,
      successMessage: json['successMessage'] as String?,
      correlationId: json['correlationId'] as String?,
      errors: json['errors'] as List<dynamic>?,
      validationErrors: json['validationErrors'] as List<dynamic>?,
    );

Map<String, dynamic> _$UserAttendanceModelToJson(
        UserAttendanceModel instance) =>
    <String, dynamic>{
      'value': instance.attendancePage,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

UserAttendanceValue _$UserAttendanceValueFromJson(Map<String, dynamic> json) =>
    UserAttendanceValue(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => UserAttendanceData.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCount: (json['totalCount'] as num?)?.toInt(),
      pageCount: (json['pageCount'] as num?)?.toInt(),
      hasNextPage: json['hasNextPage'] as bool?,
      hasPreviousPage: json['hasPreviousPage'] as bool?,
      start: (json['start'] as num?)?.toInt(),
      end: (json['end'] as num?)?.toInt(),
    );

Map<String, dynamic> _$UserAttendanceValueToJson(
        UserAttendanceValue instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalCount': instance.totalCount,
      'pageCount': instance.pageCount,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'start': instance.start,
      'end': instance.end,
    };

UserAttendanceData _$UserAttendanceDataFromJson(Map<String, dynamic> json) =>
    UserAttendanceData(
      id: (json['id'] as num?)?.toInt(),
      employeeName: json['employeeName'] as String?,
      attendanceDate: json['attendanceDate'] as String?,
      clockInTime: json['clockInTime'] as String?,
      clockOutTime: json['clockOutTime'] as String?,
      dayHours: json['dayHours'] as String?,
      totalHours: (json['totalHours'] as num?)?.toDouble(),
      location: json['location'] as String?,
      area: json['area'] as String?,
      employeeId: json['employeeId'] as String?,
      customerId: json['customerId'] as String?,
      customerName: json['customerName'] as String?,
      employeeImage: json['employeeImage'] as String?,
      isEarly: json['isEarly'] as bool?,
      isLate: json['isLate'] as bool?,
    );

Map<String, dynamic> _$UserAttendanceDataToJson(UserAttendanceData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'employeeName': instance.employeeName,
      'attendanceDate': instance.attendanceDate,
      'clockInTime': instance.clockInTime,
      'clockOutTime': instance.clockOutTime,
      'dayHours': instance.dayHours,
      'totalHours': instance.totalHours,
      'location': instance.location,
      'area': instance.area,
      'employeeId': instance.employeeId,
      'customerId': instance.customerId,
      'customerName': instance.customerName,
      'employeeImage': instance.employeeImage,
      'isEarly': instance.isEarly,
      'isLate': instance.isLate,
    };
