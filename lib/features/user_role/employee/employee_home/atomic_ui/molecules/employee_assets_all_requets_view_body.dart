import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/atoms/custom_filter_assets_requests.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/atoms/custom_filter_request_button.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/atoms/custom_request_container_list_view_body.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/atoms/custom_search_bar_and_filter_button.dart';
import 'package:flutter/material.dart';

class EmployeeAssetsAllRequetsViewBody extends StatefulWidget {
  const EmployeeAssetsAllRequetsViewBody({super.key});

  @override
  State<EmployeeAssetsAllRequetsViewBody> createState() =>
      _EmployeeAssetsAllRequetsViewBodyState();
}

class _EmployeeAssetsAllRequetsViewBodyState
    extends State<EmployeeAssetsAllRequetsViewBody> {
  late TextEditingController controller;
  List<String> buttonTitle(BuildContext context) => [
        "All".tr(context: context),
        "Approved".tr(context: context),
        "Rejected".tr(context: context),
        "Pending".tr(context: context),
      ];

  initState() {
    super.initState();
    controller = TextEditingController();
  }

  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          CustomSearchBarAndFilterButton(
            controller: controller,
            onFilterTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => CustomFilterAssetsRequests(),
              );
            },
          ),
          verticalSpace(16),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) {
                return CustomFilterRequestButton(
                  buttonTitle: buttonTitle(context)[index],
                  buttonColor: currentIndex == index
                      ? ColorsManger.blue5.withValues(alpha: 0.1)
                      : Colors.white,
                  textColor: currentIndex == index ? ColorsManger.blue5 : null,
                  onTap: () {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                );
              },
              separatorBuilder: (_, index) => horizontalSpace(16),
              itemCount: buttonTitle(context).length,
            ),
          ),
          verticalSpace(24),
          Expanded(
            flex: 13,
            child: ListView.builder(
              itemCount: 4,
              itemBuilder: (_, index) => CustomRequestContainerListViewBody(
                date: "June 12, 2025",
                moneyAmount: "5000EGP",
                moneyRemaining: "4000EGP",
                status: "Pending",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
