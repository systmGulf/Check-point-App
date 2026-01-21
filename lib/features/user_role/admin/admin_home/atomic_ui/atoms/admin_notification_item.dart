import 'dart:ui' show ImageFilter;

import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/common/app_container_decoration.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:employee_mangement/core/widgets/build_alart_message.dart';
import 'package:employee_mangement/core/widgets/custom_app_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';

class AdminNotificationItem extends StatefulWidget {
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
  State<AdminNotificationItem> createState() => _AdminNotificationItemState();
}

double value = 5;

class _AdminNotificationItemState extends State<AdminNotificationItem> {
  get imageFilter => null;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      curve: Curves.fastOutSlowIn,
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
      decoration: AppConatinerDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Add New User Request'.tr(context: context),
                      style: AppStylesManger.font14RegularBlack),
                  Text(
                    "${"Name".tr(context: context)} : ${widget.name} ",
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  horizontalSpace(8),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Row(
                      children: [
                        Text(
                          "${"Mobile ".tr(context: context)} :",
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                        ImageFiltered(
                          imageFilter:
                              ImageFilter.blur(sigmaX: value, sigmaY: value),
                          child: Text(
                            widget.mobileId,
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[700],
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        IconButton(
                            color: Colors.grey[700],
                            iconSize: 16,
                            onPressed: () {
                              setState(() {
                                if (value == 0) {
                                  value = 5;
                                } else {
                                  value = 0;
                                }
                              });
                            },
                            icon: Icon(Icons.visibility))
                      ],
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
                        onPressed: widget.onTap,
                      ),
                      Spacer(),
                      Row(
                        spacing: 6.w,
                        children: [
                          Text(
                            DateFormat(
                              tr("dd MMM", context: context),
                              context.locale.toString(),
                            ).format(widget.date),
                            style: AppStylesManger.font12RegularBlack.copyWith(
                              color: Colors.black,
                            ),
                          ),
                          SvgPicture.asset(
                            Assets.CalenderAttendanceImage,
                            height: 12.h,
                            width: 12.w,
                            colorFilter: ColorFilter.mode(
                              Colors.black,
                              BlendMode.srcIn,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IntrinsicWidth(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      buildDeleteAlertDialog(
                          message:
                              "Are you sure you want to delete this request?"
                                  .tr(context: context),
                          context,
                          title: "Delete Request".tr(context: context),
                          onYes: () {
                        context
                            .read<EmployeeCubit>()
                            .deleteAddAccountRequest(id: widget.id)
                            .then((value) {
                          context.pop();
                        });
                      });
                    },
                    icon: Icon(Icons.delete, color: ColorsManger.primaryColor),
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
