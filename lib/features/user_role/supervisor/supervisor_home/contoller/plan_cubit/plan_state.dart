part of 'plan_cubit.dart';

@immutable
abstract class PlanState {}

class PlanInitial extends PlanState {}

class SetSubPlanLoading extends PlanState {}

class SetSubPlanSuccess extends PlanState {}

class SetSubPlanError extends PlanState {
  final String error;
  SetSubPlanError({required this.error});
}

class GetPlanLoading extends PlanState {}

class GetPlanSuccess extends PlanState {
  final PlanValue planModel;
  GetPlanSuccess({required this.planModel});
}

class GetPlanError extends PlanState {
  final String error;
  GetPlanError({required this.error});
}

class GetPlansV2Loading extends PlanState {}

class GetPlansV2Success extends PlanState {
  final List<PlanV2Item> plans;
  GetPlansV2Success({required this.plans});
}

class GetPlansV2Error extends PlanState {
  final String error;
  GetPlansV2Error({required this.error});
}

class AddPlanLoading extends PlanState {}

class AddPlanSuccess extends PlanState {}

class AddPlanError extends PlanState {
  final String error;
  AddPlanError({required this.error});
}

class GetPlanByIdLoading extends PlanState {}

class GetPlanByIdSuccess extends PlanState {
  final GetPlanByIdValue planModel;
  GetPlanByIdSuccess({required this.planModel});
}

class GetPlanByIdError extends PlanState {
  final String error;
  GetPlanByIdError({required this.error});
}

class DeletePlanLoading extends PlanState {}

class DeletePlanSuccess extends PlanState {}

class DeletePlanError extends PlanState {
  final String error;
  DeletePlanError({required this.error});
}

class DeleteSubPlanLoading extends PlanState {}

class DeleteSubPlanSuccess extends PlanState {}

class DeleteSubPlanError extends PlanState {
  final String error;
  DeleteSubPlanError({required this.error});
}
