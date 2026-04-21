import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assets_model/employee_asset_requests_response.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assets_model/employee_assets_response.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_allowance_model/all_allowances_response.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_allowance_model/beneficiary_allowances_response.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_loan_model/employee_loans_response.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_loan_model/installement_types_response.dart';

class EmployeeAssetsState {
  const EmployeeAssetsState({
    this.isLoadingRequests = false,
    this.isLoadingAssets = false,
    this.isLoadingAllowances = false,
    this.isLoadingAvailableAllowances = false,
    this.isLoadingLoans = false,
    this.isLoadingInstallementTypes = false,
    this.isSubmittingRequest = false,
    this.assetRequests = const <EmployeeAssetRequestItem>[],
    this.assets = const <EmployeeAssetItem>[],
    this.allowances = const <BeneficiaryAllowanceItem>[],
    this.availableAllowances = const <AllowanceCatalogItem>[],
    this.loans = const <EmployeeLoanItem>[],
    this.installementTypes = const <InstallementTypeItem>[],
    this.errorMessage,
    this.submitErrorMessage,
    this.isRequestSubmitted = false,
  });

  final bool isLoadingRequests;
  final bool isLoadingAssets;
  final bool isLoadingAllowances;
  final bool isLoadingAvailableAllowances;
  final bool isLoadingLoans;
  final bool isLoadingInstallementTypes;
  final bool isSubmittingRequest;
  final List<EmployeeAssetRequestItem> assetRequests;
  final List<EmployeeAssetItem> assets;
  final List<BeneficiaryAllowanceItem> allowances;
  final List<AllowanceCatalogItem> availableAllowances;
  final List<EmployeeLoanItem> loans;
  final List<InstallementTypeItem> installementTypes;
  final String? errorMessage;
  final String? submitErrorMessage;
  final bool isRequestSubmitted;

  EmployeeAssetsState copyWith({
    bool? isLoadingRequests,
    bool? isLoadingAssets,
    bool? isLoadingAllowances,
    bool? isLoadingAvailableAllowances,
    bool? isLoadingLoans,
    bool? isLoadingInstallementTypes,
    bool? isSubmittingRequest,
    List<EmployeeAssetRequestItem>? assetRequests,
    List<EmployeeAssetItem>? assets,
    List<BeneficiaryAllowanceItem>? allowances,
    List<AllowanceCatalogItem>? availableAllowances,
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
      isLoadingAvailableAllowances:
          isLoadingAvailableAllowances ?? this.isLoadingAvailableAllowances,
      isLoadingLoans: isLoadingLoans ?? this.isLoadingLoans,
      isLoadingInstallementTypes:
          isLoadingInstallementTypes ?? this.isLoadingInstallementTypes,
      isSubmittingRequest: isSubmittingRequest ?? this.isSubmittingRequest,
      assetRequests: assetRequests ?? this.assetRequests,
      assets: assets ?? this.assets,
      allowances: allowances ?? this.allowances,
      availableAllowances: availableAllowances ?? this.availableAllowances,
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
