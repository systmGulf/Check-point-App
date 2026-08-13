import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/core/notifications/notification_repo.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../../../../../core/widgets/app_top_snack_bar.dart';
import '../../../../../../core/styles/styles.dart';
import '../../contoller/leave_application/leave_application_cubit.dart';

class LeaveApplicationItem extends StatefulWidget {
  const LeaveApplicationItem({
    super.key,
    required this.name,
    required this.from,
    required this.to,
    required this.reason,
    required this.id,
    required this.status,
    required this.createdBy,
    required this.type,
    required this.employeeId,
    required this.userToken,
    this.position = '',
    this.department = '',
    this.role = '',
  });

  final String name,
      from,
      to,
      reason,
      status,
      createdBy,
      type,
      employeeId,
      userToken,
      position,
      department,
      role;
  final int id;

  @override
  _LeaveApplicationItemState createState() => _LeaveApplicationItemState();
}

class _LeaveApplicationItemState extends State<LeaveApplicationItem> {
  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat(
        tr('date_format', context: context), context.locale.toString());

    final status = widget.status;
    final backgroundColor = status == 'Approved'
        ? const Color(0xFFE3F2FF)
        : status == 'Cancelled'
            ? const Color(0xFFFFE8F0)
            : const Color(0xFFFFF7ED);
    final textColor = status == 'Approved'
        ? const Color(0xFF0087FF)
        : status == 'Cancelled'
            ? const Color(0xFFE73C3C)
            : const Color(0xFFF97316);
    final iconData = status == 'Approved'
        ? Icons.check_circle_outline_rounded
        : status == 'Cancelled'
            ? Icons.cancel_outlined
            : Icons.watch_later_outlined;

    return BlocListener<LeaveApplicationCubitSupervisor, LeaveApplicationState>(
      listenWhen: (previous, current) =>
          (current is ApproveOrRejectLeaveApplicationSuccess && current.id == widget.id) ||
          (current is ApproveOrRejectLeaveApplicationFailure && current.id == widget.id),
      listener: (context, state) {
        if (state is ApproveOrRejectLeaveApplicationSuccess) {
          if (widget.userToken.isNotEmpty) {
            getIt<NotificationRepo>().sendSingleNotification(
              token: widget.userToken,
              title: 'Hi, ${widget.name}'.tr(),
              body: 'your leave request has been ${state.status.tr()}'.tr(),
            );
          }
          buildSnackBar(
            context,
            customSnackBar: CustomSnackBar.success(
              message: 'Request updated successfully'.tr(),
            ),
          );
          BlocProvider.of<LeaveApplicationCubitSupervisor>(context)
              .getLeaveApplication(type: widget.type);
        } else if (state is ApproveOrRejectLeaveApplicationFailure) {
          buildSnackBar(
            context,
            customSnackBar: CustomSnackBar.error(
              message: state.error.tr(),
            ),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: const Color(0xFFEFEFEF),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Profile Details & Status Chip
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const UserImage(imageUrl: '', height: 44),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              widget.name,
                              style: AppStylesManger.font15BoldBlack.copyWith(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w700,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (widget.role.isNotEmpty) ...[
                            SizedBox(width: 6.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 8.w, vertical: 3.h),
                              decoration: BoxDecoration(
                                color: widget.role
                                        .toLowerCase()
                                        .contains('supervisor')
                                    ? const Color(0xFFF0ECFF)
                                    : const Color(0xFFE3F2FF),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                widget.role.tr(),
                                style: TextStyle(
                                  color: widget.role
                                          .toLowerCase()
                                          .contains('supervisor')
                                      ? const Color(0xFF5F33E1)
                                      : const Color(0xFF0087FF),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (widget.department.isNotEmpty || widget.position.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 2.h),
                          child: Text(
                            '${widget.department.isNotEmpty ? widget.department : ''} ${widget.position.isNotEmpty ? "(${widget.position})" : ''}',
                            style: AppStylesManger.font15BoldBlack.copyWith(
                              color: const Color(0xFF8B8B94),
                              fontSize: 12.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                // Status Pill
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(iconData, color: textColor, size: 14.sp),
                      SizedBox(width: 4.w),
                      Text(
                        status.tr(),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 11.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Date Range Section
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16.sp,
                          color: const Color(0xFF9CA3AF),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'From'.tr(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: const Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                dateFormat.format(DateTime.parse(widget.from)),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF374151),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 24.h,
                    width: 1,
                    color: const Color(0xFFE5E7EB),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 16.sp,
                          color: const Color(0xFF9CA3AF),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'To'.tr(),
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: const Color(0xFF9CA3AF),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                dateFormat.format(DateTime.parse(widget.to)),
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF374151),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12.h),

            // Reason Block
            if (widget.reason.isNotEmpty) ...[
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${'Reason'.tr()}: ',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF374151),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.reason,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: const Color(0xFF6B7280),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),
            ],

            // Action Buttons (Only when Pending)
            if (status == 'Pending') ...[
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => approveOrCancelLeaveRequest('Approved', context),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFBBF7D0),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Approve'.tr(),
                            style: TextStyle(
                              color: const Color(0xFF15803D),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: InkWell(
                      onTap: () => approveOrCancelLeaveRequest('Cancelled', context),
                      borderRadius: BorderRadius.circular(12.r),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: const Color(0xFFFECACA),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Reject'.tr(),
                            style: TextStyle(
                              color: const Color(0xFFB91C1C),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void approveOrCancelLeaveRequest(
    String action,
    BuildContext context,
  ) {
    BlocProvider.of<LeaveApplicationCubitSupervisor>(context)
        .approveOrRejectLeaveRequest(status: action, id: widget.id);
  }
}

class RequestButton extends StatelessWidget {
  const RequestButton(
      {super.key, this.onPressed, required this.text, required this.color});
  final void Function()? onPressed;
  final Widget text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
          Radius.circular(10),
        )),
        color: color,
        onPressed: onPressed,
        child: text);
  }
}
