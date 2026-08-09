import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_plan_by_id_model.g.dart';

@JsonSerializable()
class GetPlanById {
  @JsonKey(name: 'value')
  GetPlanByIdValue? planDetails;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  GetPlanById(
      {this.planDetails,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});
  factory GetPlanById.fromJson(Map<String, dynamic> json) =>
      _$GetPlanByIdFromJson(json);

  Map<String, dynamic> toJson() => _$GetPlanByIdToJson(this);

  @Deprecated('Use planDetails instead.')
  GetPlanByIdValue? get value => planDetails;

  GetPlanByIdValue get planDetailsOrEmpty => planDetails ?? GetPlanByIdValue();
}

@JsonSerializable()
class GetPlanByIdValue {
  List<CustomerPlans>? customerPlans;
  int? id;
  String? planDate;
  String? note;

  GetPlanByIdValue({this.customerPlans, this.id, this.planDate, this.note});

  factory GetPlanByIdValue.fromJson(Map<String, dynamic> json) =>
      _$GetPlanByIdValueFromJson(json);

  Map<String, dynamic> toJson() => _$GetPlanByIdValueToJson(this);
}

@JsonSerializable()
class CustomerPlans {
  int? id;
  String? note;
  List<Employees>? employees;
  Customer? customer;
  bool? visited;

  CustomerPlans(
      {this.id, this.note, this.employees, this.customer, this.visited});

  factory CustomerPlans.fromJson(Map<String, dynamic> json) =>
      _$CustomerPlansFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerPlansToJson(this);
}

@JsonSerializable()
class Employees {
  String? position;
  String? departmentName;
  int? departmentId;
  String? branchName;
  int? branchId;
  String? role;
  bool? canAddAttendance;
  bool? canAddPlan;
  String? id;
  String? userName;
  String? name;
  String? mobileId;
  List<String>? deviceTokens;
  String? imageUrl;

  Employees(
      {this.position,
      this.departmentName,
      this.departmentId,
      this.branchName,
      this.branchId,
      this.role,
      this.canAddAttendance,
      this.canAddPlan,
      this.id,
      this.userName,
      this.name,
      this.mobileId, this.deviceTokens, this.imageUrl});

  factory Employees.fromJson(Map<String, dynamic> json) =>
      _$EmployeesFromJson(json);

  Map<String, dynamic> toJson() => _$EmployeesToJson(this);
}

@JsonSerializable()
class Customer {
  String? id;
  String? name;
  String? workesAs;
  String? location;
  String? customerType;
  List<Coordinates>? coordinates;

  Customer(
      {this.id,
      this.name,
      this.workesAs,
      this.location,
      this.customerType,
      this.coordinates});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}

@JsonSerializable()
class Coordinates {
  double? latitude;
  double? longitude;

  Coordinates({this.latitude, this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);
  Map<String, dynamic> toJson() => _$CoordinatesToJson(this);
}

typedef PlanDetailsResponse = GetPlanById;
typedef PlanDetails = GetPlanByIdValue;
