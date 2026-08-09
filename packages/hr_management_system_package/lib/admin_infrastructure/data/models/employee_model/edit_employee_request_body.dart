import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_employee_request_body.g.dart';

@JsonSerializable()
class EditEmployeeRequestBody {
  final String name;
  final String userName;
  final String position;
  final String mobileId;
  final String password;
  final String role;
  final int departmentId;
  final int branchId;

  EditEmployeeRequestBody(
      {required this.branchId,
      required this.name,
      required this.position,
      required this.mobileId,
      required this.userName,
      required this.password,
      required this.role,
      required this.departmentId});

  Map<String, dynamic> toJson() => _$EditEmployeeRequestBodyToJson(this);
}
