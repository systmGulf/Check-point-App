import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:employee_mangement/core/common/app_container_decoration.dart';
import 'package:employee_mangement/core/widgets/app_action_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';

class PlanItem extends StatelessWidget {
  const PlanItem({
    super.key,
    this.onTap,
    required this.note,
    required this.planDate,
    required this.planId,
  });
  final void Function()? onTap;
  final String note, planDate;
  final int planId;

  @override
  Widget build(BuildContext context) {
    final displayDate = _formatPlanDate(planDate);

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: AppContainerDecoration(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Row(
                children: [
                  AppActionIconButton.delete(
                    onPressed: () {
                      buildDeleteAlertDialog(
                        context,
                        title: 'Delete Plan'.tr(context: context),
                        message: 'Are you sure you want to delete this Plan?'
                            .tr(context: context),
                        onYes: () {
                          context.pop();
                          context.read<PlanCubit>().deletePlan(id: planId);
                        },
                      );
                    },
                    size: 38,
                  ),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${"Plan For".tr(context: context)} : $displayDate',
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStylesManger.font16BoldBlack.copyWith(
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          '${"Note".tr(context: context)} : ${note.trim().isEmpty ? '-' : note}',
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppStylesManger.font15RegularGrey.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  const _PlanCalendarIcon(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatPlanDate(String value) {
    final parsedDate = DateTime.tryParse(value);
    if (parsedDate == null) {
      return value.length >= 10 ? value.substring(0, 10) : value;
    }

    return DateFormat('dd-MM-yyyy').format(parsedDate);
  }
}

class _PlanCalendarIcon extends StatelessWidget {
  const _PlanCalendarIcon();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34.w,
      height: 34.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: Icon(
              Icons.calendar_month_outlined,
              size: 30.sp,
              color: Colors.black87,
            ),
          ),
          Positioned(
            bottom: -1.h,
            right: -1.w,
            child: Container(
              width: 15.w,
              height: 15.w,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.black87,
                  width: 1.1,
                ),
              ),
              child: Icon(
                Icons.access_time,
                size: 9.sp,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
