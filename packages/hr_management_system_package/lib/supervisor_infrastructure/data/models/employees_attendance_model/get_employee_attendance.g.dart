// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_employee_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupervisorGetAllEmployeesAttendanceModel
    _$SupervisorGetAllEmployeesAttendanceModelFromJson(
            Map<String, dynamic> json) =>
        SupervisorGetAllEmployeesAttendanceModel(
          attendancePage: json['value'] == null
              ? null
              : SupervisorGetAllEmployeesAttendanceValue.fromJson(
                  json['value'] as Map<String, dynamic>),
          status: (json['status'] as num?)?.toInt(),
          isSuccess: json['isSuccess'] as bool?,
          successMessage: json['successMessage'] as String?,
          correlationId: json['correlationId'] as String?,
          errors: json['errors'] as List<dynamic>?,
          validationErrors: json['validationErrors'] as List<dynamic>?,
        );

Map<String, dynamic> _$SupervisorGetAllEmployeesAttendanceModelToJson(
        SupervisorGetAllEmployeesAttendanceModel instance) =>
    <String, dynamic>{
      'value': instance.attendancePage,
      'status': instance.status,
      'isSuccess': instance.isSuccess,
      'successMessage': instance.successMessage,
      'correlationId': instance.correlationId,
      'errors': instance.errors,
      'validationErrors': instance.validationErrors,
    };

SupervisorGetAllEmployeesAttendanceValue
    _$SupervisorGetAllEmployeesAttendanceValueFromJson(
            Map<String, dynamic> json) =>
        SupervisorGetAllEmployeesAttendanceValue(
          data: (json['data'] as List<dynamic>?)
              ?.map((e) => SupervisorGetAllEmployeesAttendanceData.fromJson(
                  e as Map<String, dynamic>))
              .toList(),
          totalCount: (json['totalCount'] as num?)?.toInt(),
          pageCount: (json['pageCount'] as num?)?.toInt(),
          hasNextPage: json['hasNextPage'] as bool?,
          hasPreviousPage: json['hasPreviousPage'] as bool?,
          start: (json['start'] as num?)?.toInt(),
          end: (json['end'] as num?)?.toInt(),
        );

Map<String, dynamic> _$SupervisorGetAllEmployeesAttendanceValueToJson(
        SupervisorGetAllEmployeesAttendanceValue instance) =>
    <String, dynamic>{
      'data': instance.data,
      'totalCount': instance.totalCount,
      'pageCount': instance.pageCount,
      'hasNextPage': instance.hasNextPage,
      'hasPreviousPage': instance.hasPreviousPage,
      'start': instance.start,
      'end': instance.end,
    };

SupervisorGetAllEmployeesAttendanceData
    _$SupervisorGetAllEmployeesAttendanceDataFromJson(
            Map<String, dynamic> json) =>
        SupervisorGetAllEmployeesAttendanceData(
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
          customerPlans: (json['customerPlans'] as List<dynamic>?)
              ?.map((e) => CustomerPlan.fromJson(e as Map<String, dynamic>))
              .toList(),
        );

Map<String, dynamic> _$SupervisorGetAllEmployeesAttendanceDataToJson(
        SupervisorGetAllEmployeesAttendanceData instance) =>
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
      'customerPlans': instance.customerPlans,
    };

CustomerPlan _$CustomerPlanFromJson(Map<String, dynamic> json) => CustomerPlan(
      id: (json['id'] as num?)?.toInt(),
      note: json['note'] as String?,
      employees: (json['employees'] as List<dynamic>?)
          ?.map((e) => CustomerPlanEmployee.fromJson(e as Map<String, dynamic>))
          .toList(),
      customer: json['customer'] == null
          ? null
          : CustomerInfo.fromJson(json['customer'] as Map<String, dynamic>),
      visited: json['visited'] as bool?,
      feedbacks: (json['feedbacks'] as List<dynamic>?)
          ?.map((e) => FeedbackModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerPlanToJson(CustomerPlan instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'employees': instance.employees,
      'customer': instance.customer,
      'visited': instance.visited,
      'feedbacks': instance.feedbacks,
    };

CustomerPlanEmployee _$CustomerPlanEmployeeFromJson(
        Map<String, dynamic> json) =>
    CustomerPlanEmployee(
      position: json['position'] as String?,
      departmentName: json['departmentName'] as String?,
      departmentId: (json['departmentId'] as num?)?.toInt(),
      branchName: json['branchName'] as String?,
      branchId: (json['branchId'] as num?)?.toInt(),
      role: json['role'] as String?,
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
      name: json['name'] as String?,
      mobileId: json['mobileId'] as String?,
      deviceTokens: (json['deviceTokens'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$CustomerPlanEmployeeToJson(
        CustomerPlanEmployee instance) =>
    <String, dynamic>{
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

CustomerInfo _$CustomerInfoFromJson(Map<String, dynamic> json) => CustomerInfo(
      id: json['id'] as String?,
      name: json['name'] as String?,
      workesAs: json['workesAs'] as String?,
      location: json['location'] as String?,
      customerType: json['customerType'] as String?,
      coordinates: (json['coordinates'] as List<dynamic>?)
          ?.map((e) => CustomerCoordinate.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CustomerInfoToJson(CustomerInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'workesAs': instance.workesAs,
      'location': instance.location,
      'customerType': instance.customerType,
      'coordinates': instance.coordinates,
    };

CustomerCoordinate _$CustomerCoordinateFromJson(Map<String, dynamic> json) =>
    CustomerCoordinate(
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$CustomerCoordinateToJson(CustomerCoordinate instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
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
