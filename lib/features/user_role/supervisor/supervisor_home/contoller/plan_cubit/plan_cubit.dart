import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/core/notifications/notification_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/get_plan_by_id_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/get_plan_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/set_customer_plan_request_body.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_plans_repo/supervisor_plan_repo.dart';


import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../model/drop_down_item.dart';

part 'plan_state.dart';

class PlanCubit extends Cubit<PlanState> {
  final SupervisorPlanRepo supervisorRepo;
  PlanCubit(this.supervisorRepo) : super(PlanInitial());
  String planDate = '0';
  List<DropdownItemModel> dropdownItems = [];
  String customerId = '';
  int planId = 00;
  TextEditingController? noteController = TextEditingController();
  Future<void> getPlan() async {
    emit(GetPlanLoading());
    final result = await supervisorRepo.getPlanByDepartmentId();
    result.fold((l) {
      if (isClosed) return;

      emit(GetPlanError(error: l.message));
    }, (r) {
      if (isClosed) return;
      emit(GetPlanSuccess(planModel: r));
    });
  }

  Future<void> deletePlan({required int id}) async {
    emit(DeletePlanLoading());
    final result = await supervisorRepo.deletePlanById(id: id);
    result.fold((l) {
      if (isClosed) return;

      emit(DeletePlanError(error: l.message));
    }, (r) {
      if (isClosed) return;

      getPlan();
      emit(DeletePlanSuccess());
    });
  }

  Future<void> deleteSubPlan({required int id, required int planId}) async {
    emit(DeleteSubPlanLoading());
    final result = await supervisorRepo.deleteSubPlanById(id: id);
    result.fold((l) {
      if (isClosed) return;

      emit(DeleteSubPlanError(error: l.message));
    }, (r) {
      if (isClosed) return;

      getPlanById(id: planId);
      emit(DeleteSubPlanSuccess());
    });
  }

  Future<void> addPlan() async {
    emit(AddPlanLoading());
    if (planDate != '0') {
      final result = await supervisorRepo.setPlanByDate(
          SetPlanByDateRequestBody(
              planDate: planDate,
              note: noteController?.text ?? '',
              departmentId: ApiConstant.departmentId));
      result.fold((l) {
        if (isClosed) return;

        emit(AddPlanError(error: l.message));
      }, (r) {
        if (isClosed) return;

        getPlan();
        emit(AddPlanSuccess());
      });
    } else {
      emit(AddPlanError(error: 'Please Select Date'));
    }
  }

  Future<void> getPlanById({required int id}) async {
    emit(GetPlanByIdLoading());
    final result = await supervisorRepo.getPlanById(id: id);
    result.fold((l) {
      if (isClosed) return;

      emit(GetPlanByIdError(error: l.message));
    }, (r) {
      if (isClosed) return;

      emit(GetPlanByIdSuccess(planModel: r));
    });
  }

  Future<void> setSubPlan() async {
    emit(SetSubPlanLoading());
    if (dropdownItems.isNotEmpty && customerId != '') {
      final result = await supervisorRepo.setSubPlan(
          setSubPlansRequestBody: setSubPlansRequestBody(
              planId: planId,
              customerIdOrSiteId: customerId,
              note: noteController?.text ?? '',
              employeeIds: dropdownItems.map((e) => e.id).toList()));
      result.fold((l) {
        if (isClosed) return;

        emit(SetSubPlanError(error: l.message));
      }, (r) {
        if (isClosed) return;

        getPlanById(id: planId);
        for (var element in dropdownItems) {
          for (var token in element.employeesDeviceTokens) {
            getIt<NotificationRepo>().sendSingleNotification(
                title: 'you have New Plan ',
                body: 'you have been assigned a new plan check it out',
                token: token);
          }
        }
        emit(SetSubPlanSuccess());
      });
    } else {
      if (dropdownItems.isEmpty) {
        emit(SetSubPlanError(error: 'Please Select Employees'));
      } else {
        emit(SetSubPlanError(error: 'Please Select Customer'));
      }
    }
  }
}
