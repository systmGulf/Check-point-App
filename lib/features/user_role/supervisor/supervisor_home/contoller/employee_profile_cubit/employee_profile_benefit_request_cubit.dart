import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_benefit_model/create_employee_benefit_request_body.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_benefit_model/employee_benefits_response.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_benefit_repo/employee_benefit_repo.dart';

class EmployeeProfileBenefitRequestCubit
    extends Cubit<EmployeeProfileBenefitRequestState> {
  EmployeeProfileBenefitRequestCubit(this.employeeBenefitRepo)
      : super(const EmployeeProfileBenefitRequestState());

  final EmployeeBenefitRepo employeeBenefitRepo;

  Future<void> loadAllBenefits() async {
    emit(
      state.copyWith(
        isLoadingBenefits: true,
        clearErrorMessage: true,
        isBenefitRequested: false,
      ),
    );

    final result = await employeeBenefitRepo.getAllBenefits();
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingBenefits: false,
            errorMessage: failure.message,
          ),
        );
      },
      (benefits) {
        emit(
          state.copyWith(
            isLoadingBenefits: false,
            benefits: benefits.value,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> requestBenefit({
    required String employeeId,
    required String employeeName,
    required EmployeeBenefitItem benefit,
    required String startDate,
    required String endDate,
  }) async {
    emit(
      state.copyWith(
        isSubmitting: true,
        clearSubmitErrorMessage: true,
        isBenefitRequested: false,
      ),
    );

    final benefitId = (benefit.id ?? benefit.benefitPlanId ?? '').trim();
    if (benefitId.isEmpty) {
      emit(
        state.copyWith(
          isSubmitting: false,
          submitErrorMessage: 'Invalid benefit id',
        ),
      );
      return;
    }

    final benefitName =
        (benefit.name ?? benefit.benfitTypeName ?? 'Benefit').trim();
    final benefitPlanName =
        (benefit.planName ?? benefit.benefitPlans?.name ?? '').trim();

    final benefitElements = (benefit.benefitPlans?.benefitElements ?? const [])
        .map(
          (e) => BenefitElementBody(
            name: (e.name ?? '').trim(),
            description: (e.description ?? '').trim(),
            amount: e.amount ?? 0,
          ),
        )
        .toList();

    final requestBody = CreateEmployeeBenefitRequestBody(
      benefitId: benefitId,
      benefitName: benefitName,
      benefitPlanName: benefitPlanName,
      benefitElements: benefitElements,
      period: BenefitPeriodBody(startDate: startDate, endDate: endDate),
      status: 0,
      beneficiaryData: BeneficiaryDataBody(
        beneficiaryId: employeeId,
        name: employeeName,
        dependents: const <String>[],
      ),
      beneficiaryId: employeeId,
      dependants: const <DependantBody>[],
      name: benefitName,
      startDate: startDate,
      endDate: endDate,
    );

    final result =
        await employeeBenefitRepo.createEmployeeBenefitRequest(requestBody);
    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSubmitting: false,
            submitErrorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            isSubmitting: false,
            clearSubmitErrorMessage: true,
            isBenefitRequested: true,
          ),
        );
      },
    );
  }

  void clearBenefitRequestedFlag() {
    if (state.isBenefitRequested) {
      emit(state.copyWith(isBenefitRequested: false));
    }
  }
}

@immutable
class EmployeeProfileBenefitRequestState {
  const EmployeeProfileBenefitRequestState({
    this.isLoadingBenefits = false,
    this.isSubmitting = false,
  this.benefits = const <EmployeeBenefitItem>[],
    this.errorMessage,
    this.submitErrorMessage,
    this.isBenefitRequested = false,
  });

  final bool isLoadingBenefits;
  final bool isSubmitting;
  final List<EmployeeBenefitItem> benefits;
  final String? errorMessage;
  final String? submitErrorMessage;
  final bool isBenefitRequested;

  EmployeeProfileBenefitRequestState copyWith({
    bool? isLoadingBenefits,
    bool? isSubmitting,
    List<EmployeeBenefitItem>? benefits,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? submitErrorMessage,
    bool clearSubmitErrorMessage = false,
    bool? isBenefitRequested,
  }) {
    return EmployeeProfileBenefitRequestState(
      isLoadingBenefits: isLoadingBenefits ?? this.isLoadingBenefits,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      benefits: benefits ?? this.benefits,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      submitErrorMessage: clearSubmitErrorMessage
          ? null
          : (submitErrorMessage ?? this.submitErrorMessage),
      isBenefitRequested: isBenefitRequested ?? this.isBenefitRequested,
    );
  }
}

