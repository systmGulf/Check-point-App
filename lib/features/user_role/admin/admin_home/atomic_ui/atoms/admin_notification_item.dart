import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';

class AdminNotificationItem extends StatelessWidget {
  const AdminNotificationItem({
    super.key,
    required this.name,
    required this.mobileId,
    required this.onTap,
    required this.id,
    required this.date,
  });
  final String name, mobileId;
  final VoidCallback onTap;
  final int id;
  final DateTime date;

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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    "${"Mobile ".tr(context: context)} : $mobileId",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
                verticalSpace(10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomAppButton(
                      height: 35.h,
                      width: 100.w,
                      textButton: 'Add'.tr(context: context),
                      buttonColor: ColorsManger.primaryColor,
                      onPressed: onTap,
                    ),
                    horizontalSpace(60),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              ColorsManger.primaryColor,
                              const Color.fromARGB(255, 150, 144, 144),
                            ]),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        spacing: 6.w,
                        children: [
                          Text(
                            DateFormat(
                              tr("dd MMM", context: context),
                              context.locale.toString(),
                            ).format(date),
                            style: AppStylesManger.font16blackMedium.copyWith(
                              color: ColorsManger.scaffoldBackgroundColor,
                            ),
                          ),
                          SvgPicture.asset(
                            Assets.assetsImagesCalenderAttendance,
                            colorFilter: ColorFilter.mode(
                              ColorsManger.scaffoldBackgroundColor,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: Row(
                spacing: 16,
                children: [
                  Flexible(
                    child: Icon(
                      Icons.notifications_active,
                      color: ColorsManger.primaryColor,
                    ),
                  ),
                  Flexible(
                    child: IconButton(
                      onPressed: () {
                        context
                            .read<EmployeeCubit>()
                            .deleteAddAccountRequest(id: id);
                      },
                      icon:
                          Icon(Icons.delete, color: ColorsManger.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
