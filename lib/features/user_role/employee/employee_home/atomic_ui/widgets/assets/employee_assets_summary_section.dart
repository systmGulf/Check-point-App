import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_asset_summary_card.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_asset_status_mapper.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assets_model/employee_asset_requests_response.dart';

class EmployeeAssetsSummarySection extends StatelessWidget {
  const EmployeeAssetsSummarySection({
    super.key,
    required this.requests,
  });

  final List<EmployeeAssetRequestItem> requests;

  @override
  Widget build(BuildContext context) {
    final pendingCount = requests
        .where((e) => EmployeeAssetStatusMapper.label(e.status) == 'Pending')
        .length;
    final approvedCount = requests
        .where((e) => EmployeeAssetStatusMapper.label(e.status) == 'Approved')
        .length;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.5,
      children: [
        EmployeeAssetSummaryCard(
          title: 'My Requests',
          value: requests.length.toString(),
          icon: Icons.inventory_2_outlined,
        ),
        EmployeeAssetSummaryCard(
          title: 'Pending',
          value: pendingCount.toString(),
          icon: Icons.hourglass_bottom_rounded,
        ),
        EmployeeAssetSummaryCard(
          title: 'Approved',
          value: approvedCount.toString(),
          icon: Icons.check_circle_outline_rounded,
        ),
        EmployeeAssetSummaryCard(
          title: 'Latest Activity',
          value: requests.isEmpty ? '-' : 'Active',
          icon: Icons.timeline_rounded,
        ),
      ],
    );
  }
}
