import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/core/notifications/notification_repo.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../contoller/leave_application/leave_application_cubit.dart';

class LeaveApplicationItem extends StatefulWidget {
  const LeaveApplicationItem({
    super.key,
    this.name,
    this.from,
    this.to,
    this.reason,
    required this.id,
    required this.status,
    this.createdBy,
    this.type,
    this.employeeId,
    this.userToken,
    this.requestNumber,
    this.leaveTypeName,
    this.emergencyEmail,
    this.emergencyPhone,
  });

  final String? name;
  final String? from;
  final String? to;
  final String? reason;
  final String? createdBy;
  final String? type;
  final String? employeeId;
  final String? userToken;
  final String? requestNumber;
  final String? leaveTypeName;
  final String? emergencyEmail;
  final String? emergencyPhone;
  final int status;
  final String id;

  @override
  State<LeaveApplicationItem> createState() => _LeaveApplicationItemState();
}

class _LeaveApplicationItemState extends State<LeaveApplicationItem> {
  bool isApproved = false;
  bool isCancelled = false;

  String _statusText(BuildContext context) {
    if (isApproved) return 'Approved'.tr(context: context);
    if (isCancelled) return 'Cancelled'.tr(context: context);
    switch (widget.status) {
      case 0:
        return 'Pending'.tr(context: context);
      case 1:
        return 'Approved'.tr(context: context);
      case 2:
        return 'Rejected'.tr(context: context);
      case 3:
        return 'Cancelled'.tr(context: context);
      default:
        return '--';
    }
  }

  bool _isPending(BuildContext context) =>
      _statusText(context) == 'Pending'.tr(context: context);

  @override
  void initState() {
    super.initState();
    if (widget.status == 1) {
      isApproved = true;
    } else if (widget.status == 3 || widget.status == 2) {
      isCancelled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xffE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              UserImage(imageUrl: '', height: 42),
              horizontalSpace(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.name ?? '--',
                      style: AppStylesManger.font15BoldBlack,
                    ),
                    verticalSpace(2),
                    Text(
                      '${"Request No".tr(context: context)}: ${widget.requestNumber ?? '--'}',
                      style: AppStylesManger.font12RegularGrey,
                    ),
                  ],
                ),
              ),
              _StatusBadge(
                text: _statusText(context),
                status: _statusText(context),
              ),
            ],
          ),
          verticalSpace(10),
          _InfoRow(
            label: 'Type'.tr(context: context),
            value: widget.leaveTypeName ?? '--',
          ),
          _InfoRow(
            label: 'From'.tr(context: context),
            value: widget.from ?? '--',
          ),
          _InfoRow(
            label: 'To'.tr(context: context),
            value: widget.to ?? '--',
          ),
          _InfoRow(
            label: 'Reason'.tr(context: context),
            value: widget.reason ?? '--',
          ),
          _InfoRow(
            label: 'Emergency Email'.tr(context: context),
            value: widget.emergencyEmail ?? '--',
          ),
          _InfoRow(
            label: 'Emergency Phone'.tr(context: context),
            value: widget.emergencyPhone ?? '--',
          ),
          if (widget.type == 'Icident') ...[
            verticalSpace(4),
            Text(
              widget.employeeId == widget.createdBy
                  ? 'He is Created This Request'.tr(context: context)
                  : 'Request Created By Anther Employee'.tr(context: context),
              style: AppStylesManger.font12RegularGrey,
            ),
          ],
          if (_isPending(context)) ...[
            verticalSpace(10),
            Row(
              children: [
                Expanded(
                  child: RequestButton(
                    text: Text(
                      'Approve'.tr(context: context),
                      style: AppStylesManger.font14regularWhite.copyWith(
                        color: Colors.green[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.green[200]!,
                    onPressed: () {
                      approveOrCancelLeaveRequest('Approved', context,
                          widget.userToken ?? '', widget.name ?? '');
                    },
                  ),
                ),
                horizontalSpace(10),
                Expanded(
                  child: RequestButton(
                    text: Text(
                      'Reject'.tr(context: context),
                      style: AppStylesManger.font14RedularRed,
                    ),
                    color: Colors.red[200]!,
                    onPressed: () {
                      approveOrCancelLeaveRequest('Cancelled', context,
                          widget.userToken ?? '', widget.name ?? '');
                    },
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void approveOrCancelLeaveRequest(
    String action,
    BuildContext context,
    String userToken,
    String userName,
  ) {
    if (action == 'Approved') {
      setState(() {
        isApproved = true;
        isCancelled = false;
      });
    } else if (action == 'Cancelled') {
      setState(() {
        isApproved = false;
        isCancelled = true;
      });
    }

    final parsedId = int.tryParse(widget.id);
    if (parsedId == null) return;
    BlocProvider.of<LeaveApplicationCubitSupervisor>(context)
        .approveOrRejectLeaveRequest(status: action, id: parsedId);
    getIt<NotificationRepo>().sendSingleNotification(
      token: userToken,
      title: 'Hi, $userName'.tr(context: context),
      body: 'your leave request has been $action'.tr(context: context),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              label,
              style: AppStylesManger.font12RegularGrey,
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: AppStylesManger.font14RegularBlack,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.text,
    required this.status,
  });

  final String text;
  final String status;

  @override
  Widget build(BuildContext context) {
    Color color = Colors.orange;
    if (status.toLowerCase().contains('approved')) color = Colors.green;
    if (status.toLowerCase().contains('cancelled') ||
        status.toLowerCase().contains('rejected')) {
      color = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        text,
        style: AppStylesManger.font12RegularBlack.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class RequestButton extends StatelessWidget {
  const RequestButton({
    super.key,
    this.onPressed,
    required this.text,
    required this.color,
  });

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
        ),
      ),
      color: color,
      onPressed: onPressed,
      child: text,
    );
  }
}
