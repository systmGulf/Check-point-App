import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_asset_requests_list_section.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_assets_dashboard_skeleton.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_assets_summary_section.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/assets/employee_assets_state.dart';
import 'package:flutter/material.dart';

class EmployeeAssetsDashboardBody extends StatelessWidget {
  const EmployeeAssetsDashboardBody({
    super.key,
    required this.state,
    required this.onRefresh,
  });

  final EmployeeAssetsState state;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    if (state.isLoadingRequests && state.assetRequests.isEmpty) {
      return const EmployeeAssetsDashboardSkeleton();
    }

    if (state.errorMessage != null && state.assetRequests.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 36),
              const SizedBox(height: 12),
              Text(
                state.errorMessage!,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onRefresh,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        children: [
          EmployeeAssetsSummarySection(requests: state.assetRequests),
          const SizedBox(height: 16),
          const Text(
            'My Asset Requests',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          EmployeeAssetRequestsListSection(requests: state.assetRequests),
        ],
      ),
    );
  }
}
