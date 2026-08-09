import 'package:freezed_annotation/freezed_annotation.dart';

part 'add_employee_request_body.g.dart';

@JsonSerializable()
class AddEmployeeRequestBody {
  final String name;
  final String username;
  final String password;
  final String position;
  final String mobileId;
  final String role;
  final int departmentId;
  final int branchId;
  final List<String> deviceTokens;

  AddEmployeeRequestBody(this.deviceTokens, 
      {required this.name,
      required this.username,
      required this.password,
      required this.position,
      required this.branchId,
      required this.mobileId,
      required this.departmentId,
      required this.role});

  Map<String, dynamic> toJson() => _$AddEmployeeRequestBodyToJson(this);
}
