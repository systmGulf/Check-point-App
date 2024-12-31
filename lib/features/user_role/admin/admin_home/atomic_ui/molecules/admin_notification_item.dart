import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class AdminNotificationItem extends StatelessWidget {
  const AdminNotificationItem({
    super.key,
    required this.name,
    required this.mobileId,
    required this.onTap,
  });
  final String name, mobileId;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add New User Request'.tr(context: context),
                    style: AppStylesManger.font14RegularBlack),
                Text(
                  "${"Name".tr(context: context)} : $name ",
                  style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "${"Mobile Id".tr(context: context)} : $mobileId",
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.grey[700],
                  ),
                ),
                verticalSpace(10),
                CustomAppButton(
                  height: 35.h,
                  width: 100.w,
                  textButton: 'Add'.tr(context: context),
                  buttonColor: ColorsManger.primaryColor,
                  onPressed: onTap,
                )
              ],
            ),
            Icon(
              Icons.notifications_active,
              color: ColorsManger.primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
