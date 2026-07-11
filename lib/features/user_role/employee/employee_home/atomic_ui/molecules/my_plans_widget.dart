import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/build_alart_message.dart';
import 'package:employee_mangement/core/widgets/app_action_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_attendance_model/get_plan_by_employee_id_model.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/feed_back_in_plan_widget.dart';
import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import '../../controller/attendence/attendence_cubit.dart';

class MyPlanWidget extends StatelessWidget {
  const MyPlanWidget({
    super.key,
    required this.planDate,
    required this.now,
    required this.item,
  });

  final dynamic planDate;
  final DateTime now;
  final Data item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: DateUtils.isSameDay(planDate, now)
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    DateUtils.isSameDay(planDate, now)
                        ? 'The plan is Today'.tr()
                        : planDate.isBefore(now)
                            ? 'The plan is Over'.tr()
                            : '${planDate.difference(now).inDays} ${"Days Left".tr()}',
                    style: DateUtils.isSameDay(planDate, now)
                        ? AppStylesManger.font14RedularGreen
                            .copyWith(fontWeight: FontWeight.bold)
                        : AppStylesManger.font14RedularRed
                            .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "Status".tr(),
                      style: AppStylesManger.font14RegularBlack.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " : ${item.visited == true ? "Visited".tr() : "Not Visited".tr()}",
                      style: AppStylesManger.font14RegularBlack.copyWith(
                        color: item.visited == true ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      ' ${"Notes".tr()}',
                      style: AppStylesManger.font14RegularBlack.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        ' : ${item.note != null || item.note != '' ? ' No Notes'.tr() : item.note}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppStylesManger.font14RegularBlack,
                      ),
                    ),
                  ],
                ),
                Divider(thickness: 1),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[200],
                      child: Icon(
                        Icons.person,
                        size: 20,
                        color: ColorsManger.primaryColor,
                      ),
                    ),
                    horizontalSpace(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.customer!.name!,
                          style: AppStylesManger.font14RegularBlack.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item.customer!.workesAs ?? '',
                          style:
                              AppStylesManger.font11clamgrey400weight.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                item.visited == true
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpace(10),
                          InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                  backgroundColor: Colors.white,
                                  context: context,
                                  builder: (_) => item.feedbacks != null &&
                                          item.feedbacks!.isNotEmpty
                                      ? Column(
                                          children: [
                                            verticalSpace(10),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              child: Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .topEnd,
                                                  child: IconButton(
                                                    onPressed: () =>
                                                        context.pop(),
                                                    icon: Icon(
                                                      Icons.close,
                                                      color: ColorsManger
                                                          .primaryColor,
                                                    ),
                                                  )),
                                            ),
                                            Expanded(
                                              child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount:
                                                      item.feedbacks?.length ??
                                                          0,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return IntrinsicHeight(
                                                      child:
                                                          FeedBackInPlanWidget(
                                                        feedBack: item
                                                                .feedbacks?[
                                                                    index]
                                                                .notes ??
                                                            '',
                                                        status: item
                                                                .feedbacks?[
                                                                    index]
                                                                .status ??
                                                            '',
                                                        imageUrl: item
                                                                .feedbacks?[
                                                                    index]
                                                                .imageUrl ??
                                                            '',
                                                      ),
                                                    );
                                                  }),
                                            ),
                                          ],
                                        )
                                      : NoDataFound());
                            },
                            child: Text(
                              "Feedback".tr(),
                              style:
                                  AppStylesManger.font13DarkBlueMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          const Spacer(),
          AppActionIconButton.delete(
            onPressed: () {
              buildDeleteAlertDialog(
                  message: 'Are you sure you want to delete this plan?'
                      .tr(),
                  context,
                  title: 'Delete Plan'.tr(), onYes: () {
                context.read<AttendanceCubit>().removeAssignCustomerPlan(
                      customerPlanId: item.id!,
                    );
              });
            },
            size: 34,
          )
        ],
      ),
    );
  }
}
