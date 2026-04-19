import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assets_model/employee_asset_requests_response.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assets_model/employee_assets_response.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_allowance_model/beneficiary_allowances_response.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_loan_model/employee_loans_response.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_loan_model/installement_types_response.dart';

class EmployeeAssetsState {
  const EmployeeAssetsState({
    this.isLoadingRequests = false,
    this.isLoadingAssets = false,
    this.isLoadingAllowances = false,
    this.isLoadingLoans = false,
    this.isLoadingInstallementTypes = false,
    this.isSubmittingRequest = false,
    this.assetRequests = const <EmployeeAssetRequestItem>[],
    this.assets = const <EmployeeAssetItem>[],
    this.allowances = const <BeneficiaryAllowanceItem>[],
    this.loans = const <EmployeeLoanItem>[],
    this.installementTypes = const <InstallementTypeItem>[],
    this.errorMessage,
    this.submitErrorMessage,
    this.isRequestSubmitted = false,
  });

  final bool isLoadingRequests;
  final bool isLoadingAssets;
  final bool isLoadingAllowances;
  final bool isLoadingLoans;
  final bool isLoadingInstallementTypes;
  final bool isSubmittingRequest;
  final List<EmployeeAssetRequestItem> assetRequests;
  final List<EmployeeAssetItem> assets;
  final List<BeneficiaryAllowanceItem> allowances;
  final List<EmployeeLoanItem> loans;
  final List<InstallementTypeItem> installementTypes;
  final String? errorMessage;
  final String? submitErrorMessage;
  final bool isRequestSubmitted;

  EmployeeAssetsState copyWith({
    bool? isLoadingRequests,
    bool? isLoadingAssets,
    bool? isLoadingAllowances,
    bool? isLoadingLoans,
    bool? isLoadingInstallementTypes,
    bool? isSubmittingRequest,
    List<EmployeeAssetRequestItem>? assetRequests,
    List<EmployeeAssetItem>? assets,
    List<BeneficiaryAllowanceItem>? allowances,
    List<EmployeeLoanItem>? loans,
    List<InstallementTypeItem>? installementTypes,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? submitErrorMessage,
    bool clearSubmitErrorMessage = false,
    bool? isRequestSubmitted,
  }) {
    return EmployeeAssetsState(
      isLoadingRequests: isLoadingRequests ?? this.isLoadingRequests,
      isLoadingAssets: isLoadingAssets ?? this.isLoadingAssets,
      isLoadingAllowances: isLoadingAllowances ?? this.isLoadingAllowances,
      isLoadingLoans: isLoadingLoans ?? this.isLoadingLoans,
      isLoadingInstallementTypes:
          isLoadingInstallementTypes ?? this.isLoadingInstallementTypes,
      isSubmittingRequest: isSubmittingRequest ?? this.isSubmittingRequest,
      assetRequests: assetRequests ?? this.assetRequests,
      assets: assets ?? this.assets,
      allowances: allowances ?? this.allowances,
      loans: loans ?? this.loans,
      installementTypes: installementTypes ?? this.installementTypes,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      submitErrorMessage: clearSubmitErrorMessage
          ? null
          : (submitErrorMessage ?? this.submitErrorMessage),
      isRequestSubmitted: isRequestSubmitted ?? this.isRequestSubmitted,
    );
  }
}
