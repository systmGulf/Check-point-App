import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/core/notifications/notification_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/get_plan_by_id_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/get_plan_model.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_plans_repo/supervisor_plan_repo.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/plan_model/set_customer_plan_request_body.dart'
    show SetPlanByDateRequestBody, SetSubPlansRequestBody;

import '../../model/drop_down_item.dart';

part 'plan_state.dart';

class PlanCubit extends Cubit<PlanState> {
  PlanCubit({
    required this.supervisorPlanRepo,
    required this.notificationRepo,
  }) : super(PlanInitial());

  final SupervisorPlanRepo supervisorPlanRepo;
  final NotificationRepo notificationRepo;
  final TextEditingController noteController = TextEditingController();
  final List<DropdownItemModel> dropdownItems = [];
  String planDate = '0';
  String customerId = '';
  int planId = 0;

  Future<void> getPlan() async {
    emit(GetPlanLoading());
    final result = await supervisorPlanRepo.getPlanByDepartmentId();
    result.fold(
      (l) {
        if (!isClosed) emit(GetPlanError(error: l.message));
      },
      (r) {
        if (!isClosed) emit(GetPlanSuccess(planModel: r));
      },
    );
  }

  Future<void> deletePlan({required int id}) async {
    emit(DeletePlanLoading());
    final result = await supervisorPlanRepo.deletePlanById(id: id);
    result.fold(
      (l) {
        if (!isClosed) emit(DeletePlanError(error: l.message));
      },
      (r) {
        if (!isClosed) emit(DeletePlanSuccess());
        getPlan();
      },
    );
  }

  Future<void> deleteSubPlan({
    required int id,
    required int planId,
  }) async {
    emit(DeleteSubPlanLoading());
    final result = await supervisorPlanRepo.deleteSubPlanById(id: id);
    result.fold(
      (l) {
        if (!isClosed) emit(DeleteSubPlanError(error: l.message));
      },
      (r) {
        if (!isClosed) emit(DeleteSubPlanSuccess());
        getPlanById(id: planId);
      },
    );
  }

  Future<void> addPlan({
    String? planDate,
    String? note,
  }) async {
    emit(AddPlanLoading());
    final selectedPlanDate = planDate ?? this.planDate;
    final noteValue = note ?? noteController.text.trim();
    if (selectedPlanDate == '0' || selectedPlanDate.isEmpty) {
      emit(AddPlanError(error: 'supervisor.plan.selectDate'));
      return;
    }
    final requestBody = SetPlanByDateRequestBody(
      planDate: selectedPlanDate,
      note: noteValue,
      departmentId: ApiConstant.departmentId,
    );
    final result = await supervisorPlanRepo.setPlanByDate(requestBody);
    result.fold(
      (l) {
        if (!isClosed) emit(AddPlanError(error: l.message));
      },
      (r) {
        if (!isClosed) emit(AddPlanSuccess());
        getPlan();
      },
    );
  }

  Future<void> getPlanById({required int id}) async {
    emit(GetPlanByIdLoading());
    final result = await supervisorPlanRepo.getPlanById(id: id);
    result.fold(
      (l) {
        if (!isClosed) emit(GetPlanByIdError(error: l.message));
      },
      (r) {
        if (!isClosed) emit(GetPlanByIdSuccess(planModel: r));
      },
    );
  }

  Future<void> setSubPlan({
    int? planId,
    String? customerId,
    List<DropdownItemModel>? employees,
    String? note,
  }) async {
    final selectedPlanId = planId ?? this.planId;
    final selectedCustomerId = customerId ?? this.customerId;
    final selectedEmployees = employees ?? dropdownItems;
    final noteValue = note ?? noteController.text.trim();
    if (selectedEmployees.isEmpty) {
      emit(SetSubPlanError(error: 'supervisor.plan.selectEmployees'));
      return;
    }
    if (selectedCustomerId.isEmpty) {
      emit(SetSubPlanError(error: 'supervisor.plan.selectCustomer'));
      return;
    }
    if (selectedPlanId == 0) {
      emit(SetSubPlanError(error: 'supervisor.plan.selectPlan'));
      return;
    }

    emit(SetSubPlanLoading());
    final requestBody = SetSubPlansRequestBody(
      planId: selectedPlanId,
      customerIdOrSiteId: selectedCustomerId,
      note: noteValue,
      employeeIds: selectedEmployees.map((e) => e.id).toList(),
    );
    final result = await supervisorPlanRepo.setSubPlan(
      setSubPlansRequestBody: requestBody,
    );
    result.fold(
      (l) {
        if (!isClosed) emit(SetSubPlanError(error: l.message));
      },
      (r) {
        if (!isClosed) {
          getPlanById(id: selectedPlanId);
          _notifyEmployees(
            employees: selectedEmployees,
            title: 'you have New Plan',
            body: 'you have been assigned a new plan check it out',
          );
          emit(SetSubPlanSuccess());
        }
      },
    );
  }

  void _notifyEmployees({
    required List<DropdownItemModel> employees,
    required String title,
    required String body,
  }) {
    for (final employee in employees) {
      for (final token in employee.employeesDeviceTokens) {
        notificationRepo.sendSingleNotification(
          title: title,
          body: body,
          token: token,
        );
      }
    }
  }

  @override
  Future<void> close() {
    noteController.dispose();
    return super.close();
  }
}
