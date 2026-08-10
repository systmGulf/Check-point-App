import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_plan_by_employee_id_model.g.dart';

@JsonSerializable()
class EmployeePlansModel {
  Value? value;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  EmployeePlansModel(
      {this.value,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});

  factory EmployeePlansModel.fromJson(Map<String, dynamic> json) =>
      _$EmployeePlansModelFromJson(json);

  List<Data>? get data => value?.data;
}

@JsonSerializable()
class Value {
  List<Data>? data;
  int? totalCount;
  int? pageCount;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? start;
  int? end;

  Value(
      {this.data,
      this.totalCount,
      this.pageCount,
      this.hasNextPage,
      this.hasPreviousPage,
      this.start,
      this.end});

  factory Value.fromJson(Map<String, dynamic> json) => _$ValueFromJson(json);
}

@JsonSerializable()
class Data {
  int? id;
  String? note;
  Customer? customer;
  Plan? plan;
  bool? visited;
  List<FeedbackModel>? feedbacks;
  String? createdDate;

  Data(
      {this.id,
      this.note,
      this.customer,
      this.plan,
      this.visited,
      this.feedbacks,
      this.createdDate});

  factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);
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
}

@JsonSerializable()
class Coordinates {
  double? latitude;
  double? longitude;

  Coordinates({this.latitude, this.longitude});

  factory Coordinates.fromJson(Map<String, dynamic> json) =>
      _$CoordinatesFromJson(json);
}

@JsonSerializable()
class Plan {
  int? id;
  DateTime? planDate;
  String? note;
  String? departmentName;

  Plan({this.id, this.planDate, this.note, this.departmentName});

  factory Plan.fromJson(Map<String, dynamic> json) => _$PlanFromJson(json);
}
@JsonSerializable()
class FeedbackModel {
  int? id;
  String? imageUrl;
  String? notes;
  String? status;

  FeedbackModel({
    this.id,
    this.imageUrl,
    this.notes,
    this.status,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) =>
      _$FeedbackModelFromJson(json);
}
