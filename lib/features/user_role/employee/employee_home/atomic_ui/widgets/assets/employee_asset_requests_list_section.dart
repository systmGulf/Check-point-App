import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/widgets/assets/employee_asset_request_card.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_assets_model/employee_asset_requests_response.dart';

class EmployeeAssetRequestsListSection extends StatelessWidget {
  const EmployeeAssetRequestsListSection({
    super.key,
    required this.requests,
  });

  final List<EmployeeAssetRequestItem> requests;

  @override
  Widget build(BuildContext context) {
    if (requests.isEmpty) {
      return const Center(
        child: Text('No asset requests yet'),
      );
    }

    return Column(
      children: List<Widget>.generate(
        requests.length,
        (index) => Padding(
          padding:
              EdgeInsets.only(bottom: index == requests.length - 1 ? 0 : 10),
          child: EmployeeAssetRequestCard(request: requests[index]),
        ),
      ),
    );
  }
}
