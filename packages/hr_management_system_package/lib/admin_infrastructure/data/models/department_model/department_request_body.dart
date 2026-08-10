import 'package:freezed_annotation/freezed_annotation.dart';

part 'department_request_body.g.dart';

@JsonSerializable()
class DepartmentRequestBody {
  final String departmentName;

  const DepartmentRequestBody({required this.departmentName});

  factory DepartmentRequestBody.fromJson(Map<String, dynamic> json) =>
      _$DepartmentRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$DepartmentRequestBodyToJson(this);
}
