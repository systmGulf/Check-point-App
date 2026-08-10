import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_check_in_request_body.g.dart';

@JsonSerializable()
class EmployeeCheckInRequestBody {
  @JsonKey(name: 'employeeId')
  final String employeeIdd;
  final String area;
  final String? customerId;
  final String location;
  final String? employeeImage;
  final List<AttendanceCoordinate>? coordinates;

  EmployeeCheckInRequestBody(
    this.customerId,
    this.employeeImage, {
    required this.employeeIdd,
    required this.area,
    required this.location,
    this.coordinates,
  });

  Map<String, dynamic> toJson() => _$EmployeeCheckInRequestBodyToJson(this);
}

@JsonSerializable()
class AttendanceCoordinate {
  final double latitude;
  final double longitude;

  const AttendanceCoordinate({
    required this.latitude,
    required this.longitude,
  });

  factory AttendanceCoordinate.fromJson(Map<String, dynamic> json) =>
      _$AttendanceCoordinateFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceCoordinateToJson(this);
}
