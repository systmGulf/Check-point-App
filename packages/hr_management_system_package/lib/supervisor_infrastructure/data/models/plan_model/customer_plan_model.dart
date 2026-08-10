import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_plan_model.g.dart';

@JsonSerializable()
class CustomerPlanModel {
  List<CustomerPlanValue>? value;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  CustomerPlanModel(
      {this.value,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});

  Map<String, dynamic> toJson() => _$CustomerPlanModelToJson(this);
  factory CustomerPlanModel.fromJson(Map<String, dynamic> json) =>
      _$CustomerPlanModelFromJson(json);
}

@JsonSerializable()
class CustomerPlanValue {
  int? id;
  String? planDate;
  String? note;
  List<Employees>? employees;
  List<Customer>? customers;

  CustomerPlanValue(
      {this.id, this.planDate, this.note, this.employees, this.customers});

  Map<String, dynamic> toJson() => _$CustomerPlanValueToJson(this);
  factory CustomerPlanValue.fromJson(Map<String, dynamic> json) =>
      _$CustomerPlanValueFromJson(json);
}

@JsonSerializable()
class Employees {
  String? position;
  String? departmentName;
  int? departmentId;
  String? branchName;
  int? branchId;
  String? role;
  String? id;
  String? userName;
  String? name;
  String? mobileId;

  Employees(
      {this.position,
      this.departmentName,
      this.departmentId,
      this.branchName,
      this.branchId,
      this.role,
      this.id,
      this.userName,
      this.name,
      this.mobileId});

  Map<String, dynamic> toJson() => _$EmployeesToJson(this);
  factory Employees.fromJson(Map<String, dynamic> json) =>
      _$EmployeesFromJson(json);
}

@JsonSerializable()
class Customer {
  String? id;
  String? name;
  String? workesAs;
  String? location;
  List<Coordinates>? coordinates;

  Customer(
      {this.id, this.name, this.workesAs, this.location, this.coordinates});

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

@JsonSerializable()
class Coordinates {
  double? latitude;
  double? longitude;

  Coordinates({this.latitude, this.longitude});

  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);
}
