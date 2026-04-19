import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assets_model/employee_asset_requests_response.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assets_model/employee_assets_response.dart';

class EmployeeAssetsState {
  const EmployeeAssetsState({
    this.isLoadingRequests = false,
    this.isLoadingAssets = false,
    this.isSubmittingRequest = false,
    this.assetRequests = const <EmployeeAssetRequestItem>[],
    this.assets = const <EmployeeAssetItem>[],
    this.errorMessage,
    this.submitErrorMessage,
    this.isRequestSubmitted = false,
  });

  final bool isLoadingRequests;
  final bool isLoadingAssets;
  final bool isSubmittingRequest;
  final List<EmployeeAssetRequestItem> assetRequests;
  final List<EmployeeAssetItem> assets;
  final String? errorMessage;
  final String? submitErrorMessage;
  final bool isRequestSubmitted;

  EmployeeAssetsState copyWith({
    bool? isLoadingRequests,
    bool? isLoadingAssets,
    bool? isSubmittingRequest,
    List<EmployeeAssetRequestItem>? assetRequests,
    List<EmployeeAssetItem>? assets,
    String? errorMessage,
    bool clearErrorMessage = false,
    String? submitErrorMessage,
    bool clearSubmitErrorMessage = false,
    bool? isRequestSubmitted,
  }) {
    return EmployeeAssetsState(
      isLoadingRequests: isLoadingRequests ?? this.isLoadingRequests,
      isLoadingAssets: isLoadingAssets ?? this.isLoadingAssets,
      isSubmittingRequest: isSubmittingRequest ?? this.isSubmittingRequest,
      assetRequests: assetRequests ?? this.assetRequests,
      assets: assets ?? this.assets,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
      submitErrorMessage: clearSubmitErrorMessage
          ? null
          : (submitErrorMessage ?? this.submitErrorMessage),
      isRequestSubmitted: isRequestSubmitted ?? this.isRequestSubmitted,
    );
  }
}
