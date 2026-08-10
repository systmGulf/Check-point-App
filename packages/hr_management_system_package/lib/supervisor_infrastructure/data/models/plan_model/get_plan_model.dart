
import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_plan_model.g.dart';
 @JsonSerializable()
class PlanModel {
  @JsonKey(name: 'value')
  PlanValue? plansPage;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  PlanModel(
      {this.plansPage,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});

  factory PlanModel.fromJson(Map<String, dynamic> json) => _$PlanModelFromJson(json);

  @Deprecated('Use plansPage instead.')
  PlanValue? get value => plansPage;

  PlanValue get plansPageOrEmpty => plansPage ?? PlanValue();
}
@JsonSerializable()

class PlanValue {
  List<PlanData>? data;
  int? totalCount;
  int? pageCount;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? start;
  int? end;

  PlanValue(
      {this.data,
      this.totalCount,
      this.pageCount,
      this.hasNextPage,
      this.hasPreviousPage,
      this.start,
      this.end});
factory PlanValue.fromJson(Map<String, dynamic> json) => _$PlanValueFromJson(json);
}
@JsonSerializable()

class PlanData {
  int? id;
  String? planDate;
  String? note;

  PlanData({this.id, this.planDate, this.note});
  factory PlanData.fromJson(Map<String, dynamic> json) => _$PlanDataFromJson(json);
}

typedef PlansResponse = PlanModel;
typedef PlansPage = PlanValue;
