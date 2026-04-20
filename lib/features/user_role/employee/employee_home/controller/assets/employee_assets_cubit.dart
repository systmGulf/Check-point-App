import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/core/core.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assets_model/request_asset_request_body.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_loan_model/create_loan_request_body.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_allowance_repo/employee_allowance_repo.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_assets_repo/employee_assets_repo.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_loan_repo/employee_loan_repo.dart';

import 'employee_assets_state.dart';

class EmployeeAssetsCubit extends Cubit<EmployeeAssetsState> {
  EmployeeAssetsCubit(
    this.employeeAssetsRepo,
    this.employeeAllowanceRepo,
    this.employeeLoanRepo,
  ) : super(const EmployeeAssetsState());

  final EmployeeAssetsRepo employeeAssetsRepo;
  final EmployeeAllowanceRepo employeeAllowanceRepo;
  final EmployeeLoanRepo employeeLoanRepo;

  Future<void> loadDashboard({String? employeeId}) async {
    emit(
      state.copyWith(
        isLoadingRequests: true,
        clearErrorMessage: true,
        isRequestSubmitted: false,
      ),
    );

    final result = await employeeAssetsRepo.getAssetsForEmployee(
      employeeId: employeeId,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingRequests: false,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            isLoadingRequests: false,
            assetRequests: success.value,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> loadAssets() async {
    emit(
      state.copyWith(
        isLoadingAssets: true,
        clearErrorMessage: true,
        isRequestSubmitted: false,
      ),
    );

    final result = await employeeAssetsRepo.getAllAssets();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingAssets: false,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            isLoadingAssets: false,
            assets: success.value,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> loadAllowances({String? employeeId}) async {
    emit(
      state.copyWith(
        isLoadingAllowances: true,
        clearErrorMessage: true,
        isRequestSubmitted: false,
      ),
    );
    employeeId = ApiConstant.employeeId;

    final result = await employeeAllowanceRepo.getBeneficiaryAllowances(
      employeeId: employeeId,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingAllowances: false,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            isLoadingAllowances: false,
            allowances: success.value,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> loadLoans() async {
    emit(
      state.copyWith(
        isLoadingLoans: true,
        clearErrorMessage: true,
        isRequestSubmitted: false,
      ),
    );

    final employeeId = ApiConstant.employeeId;

    final result =
        await employeeLoanRepo.getAllLoans(targetEmployeeId: employeeId);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingLoans: false,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            isLoadingLoans: false,
            loans: success.value,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> loadInstallementTypes() async {
    emit(
      state.copyWith(
        isLoadingInstallementTypes: true,
        clearErrorMessage: true,
        isRequestSubmitted: false,
      ),
    );

    final result = await employeeLoanRepo.getInstallementTypes();

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isLoadingInstallementTypes: false,
            errorMessage: failure.message,
          ),
        );
      },
      (success) {
        emit(
          state.copyWith(
            isLoadingInstallementTypes: false,
            installementTypes: success.value,
            clearErrorMessage: true,
          ),
        );
      },
    );
  }

  Future<void> submitAssetRequest({
    required String employeeId,
    required String assetId,
    required String note,
  }) async {
    emit(
      state.copyWith(
        isSubmittingRequest: true,
        clearSubmitErrorMessage: true,
        isRequestSubmitted: false,
      ),
    );

    final request = RequestAssetRequestBody(
      employeeId: employeeId,
      assetId: assetId,
      requestNotes: note,
    );

    final result = await employeeAssetsRepo.requestAsset(request);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSubmittingRequest: false,
            submitErrorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            isSubmittingRequest: false,
            clearSubmitErrorMessage: true,
            isRequestSubmitted: true,
          ),
        );
      },
    );
  }

  Future<void> submitLoanRequest({
    required String code,
    required String installementTypeId,
    required num amount,
    required String startDate,
    required String endDate,
    required String requesterId,
    required String requesterName,
    int status = 0,
  }) async {
    emit(
      state.copyWith(
        isSubmittingRequest: true,
        clearSubmitErrorMessage: true,
        isRequestSubmitted: false,
      ),
    );

    final request = CreateLoanRequestBody(
      requesterId: requesterId,
      installementTypeId: installementTypeId,
      period: LoanPeriodBody(
        startDate: startDate,
        endDate: endDate,
      ),
      amount: amount,
    );

    final result = await employeeLoanRepo.createLoanRequest(request);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSubmittingRequest: false,
            submitErrorMessage: failure.message,
          ),
        );
      },
      (_) {
        emit(
          state.copyWith(
            isSubmittingRequest: false,
            clearSubmitErrorMessage: true,
            isRequestSubmitted: true,
          ),
        );
      },
    );
  }

  void clearRequestSubmissionFlag() {
    if (state.isRequestSubmitted) {
      emit(state.copyWith(isRequestSubmitted: false));
    }
  }
}
