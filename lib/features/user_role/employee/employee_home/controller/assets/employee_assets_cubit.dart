import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assets_model/request_asset_request_body.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/repo/employee_assets_repo/employee_assets_repo.dart';

import 'employee_assets_state.dart';

class EmployeeAssetsCubit extends Cubit<EmployeeAssetsState> {
  EmployeeAssetsCubit(this.employeeAssetsRepo)
      : super(const EmployeeAssetsState());

  final EmployeeAssetsRepo employeeAssetsRepo;

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

  void clearRequestSubmissionFlag() {
    if (state.isRequestSubmitted) {
      emit(state.copyWith(isRequestSubmitted: false));
    }
  }
}
