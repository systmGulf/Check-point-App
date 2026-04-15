import 'package:employee_mangement/core/utils/assets_manager.dart' show Assets;
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/atoms/custom_employee_recent_list_view_item.dart';
import 'package:flutter/material.dart';


class CustomEmployeeRecentHistoryListViewContainer extends StatefulWidget {
  const CustomEmployeeRecentHistoryListViewContainer({super.key});

  @override
  State<CustomEmployeeRecentHistoryListViewContainer> createState() =>
      _CustomEmployeeRecentHistoryListViewContainerState();
}

class _CustomEmployeeRecentHistoryListViewContainerState
    extends State<CustomEmployeeRecentHistoryListViewContainer> {
  final List<String> icons = [
    Assets.assetsImagesCancelContainer,
    Assets.assetsImagesDoneContainer,
    Assets.assetsImagesClockGlassYallow,
  ];
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListView.builder(
          itemCount: 3,
          itemBuilder: (_, index) {
            return CustomEmployeeRecentListViewItem(
              amount: "-1,000 EGP",
              date: "June 12, 2025",
              icon: icons[index],
              title: "Emergency Expense",
            );
          },
        ),
      ),
    );
  }
}
