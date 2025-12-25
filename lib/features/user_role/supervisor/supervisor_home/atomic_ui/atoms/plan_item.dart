import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Card(
        
            color: Colors.white,
            shape: RoundedRectangleBorder(
              
              borderRadius: BorderRadius.circular(12.r),
              side: const BorderSide(color: Colors.grey),
            ),
            child: ListTile(
                leading:
                    Image.asset('assets/images/planning.png', height: 30.h),
                title: Text(
                  '${"Plan For".tr(context: context)} : ${planDate.substring(0, 10)}',
                  style:
                      AppStylesManger.font16BoldBlack.copyWith(fontSize: 14.sp),
                ),
                subtitle: Text(
                  '${"Note".tr(context: context)} : $note',
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: InkWell(
                  onTap: () {
                    buildDeleteAlertDialog(context,
                        title: 'Delete Plan'.tr(context: context),
                        message: 'Are you sure you want to delete this Plan?'.tr(context: context)
                            .tr(context: context), onYes: () {
                      context.pop();
                      context.read<PlanCubit>().deletePlan(id: planId);
                    });
                  },
                  child: SvgPicture.asset('assets/images/delete_icon.svg',
                      height: 24.h),
                ))),
      ),
    );
  }
}
