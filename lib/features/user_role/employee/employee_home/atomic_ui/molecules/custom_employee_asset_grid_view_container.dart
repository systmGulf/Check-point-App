import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/atoms/custom_asset_grid_view_item.dart';
import 'package:flutter/material.dart';

class CustomEmployeeAssetGridViewContainer extends StatefulWidget {
  const CustomEmployeeAssetGridViewContainer({super.key});

  @override
  State<CustomEmployeeAssetGridViewContainer> createState() =>
      _CustomEmployeeAssetGridViewContainerState();
}

class _CustomEmployeeAssetGridViewContainerState
    extends State<CustomEmployeeAssetGridViewContainer> {
  final List<String> imgs = [
    Assets.assetsImagesWallet,
    Assets.assetsImagesClockGlassContainer,
    Assets.assetsImagesMoneyContainer,
    Assets.assetsImagesMoneyContainer,
  ];

  List<String> titles(BuildContext context) => [
        "Total Assigned".tr(context: context),
        "Pending Requests".tr(context: context),
        "Amount Spent".tr(context: context),
        "Remaining Balance".tr(context: context),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "My Assets".tr(context: context),
              style: AppStylesManger.font16BoldBlack,
            ),
            verticalSpace(16),
            Expanded(
              child: GridView.builder(
                itemCount: 4,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.4,
                ),
                itemBuilder: (_, index) {
                  return CustomAssetGridViewItem(
                    image: imgs[index],
                    title: titles(context)[index],
                    money: "5,000 EGP",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
