import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_branches_models.g.dart';

@JsonSerializable()
class GetBranchesModel {
  @JsonKey(name: 'value')
  GetBranchesValue? branchesPage;
  int? status;
  bool? isSuccess;
  String? successMessage;
  String? correlationId;
  List<dynamic>? errors;
  List<dynamic>? validationErrors;

  GetBranchesModel(
      {this.branchesPage,
      this.status,
      this.isSuccess,
      this.successMessage,
      this.correlationId,
      this.errors,
      this.validationErrors});

  factory GetBranchesModel.fromJson(Map<String, dynamic> json) =>
      _$GetBranchesModelFromJson(json);

  @Deprecated('Use branchesPage instead.')
  GetBranchesValue? get value => branchesPage;

  GetBranchesValue get branchesPageOrEmpty => branchesPage ?? GetBranchesValue();
}

@JsonSerializable()
class GetBranchesValue {
  List<GetBranchesData>? data;
  int? totalCount;
  int? pageCount;
  bool? hasNextPage;
  bool? hasPreviousPage;
  int? start;
  int? end;

  GetBranchesValue(
      {this.data,
      this.totalCount,
      this.pageCount,
      this.hasNextPage,
      this.hasPreviousPage,
      this.start,
      this.end});

  factory GetBranchesValue.fromJson(Map<String, dynamic> json) =>
      _$GetBranchesValueFromJson(json);
}

@JsonSerializable()
class GetBranchesData {
  int? id;
  String? name;
  String? location;
  String? description;
  List<GetBranchesCoordinates>? coordinates;

  GetBranchesData(
      {this.id, this.name, this.location, this.description, this.coordinates});

  factory GetBranchesData.fromJson(Map<String, dynamic> json) =>
      _$GetBranchesDataFromJson(json);
}

@JsonSerializable()
class GetBranchesCoordinates {
  double? latitude;
  double? longitude;

  GetBranchesCoordinates({this.latitude, this.longitude});

  factory GetBranchesCoordinates.fromJson(Map<String, dynamic> json) =>
      _$GetBranchesCoordinatesFromJson(json);
}

typedef BranchesResponse = GetBranchesModel;
typedef BranchesPage = GetBranchesValue;
