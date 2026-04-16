import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/atoms/taks_card.dart';
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
    this.status,
    this.createdBy,
    this.type,
    this.employeeId,
    this.userToken,
  });

  final String? name,
      from,
      to,
      reason,
      status,
      createdBy,
      type,
      employeeId,
      userToken;
  final int id;

  @override
  _LeaveApplicationItemState createState() => _LeaveApplicationItemState();
}

class _LeaveApplicationItemState extends State<LeaveApplicationItem> {
  bool isApproved = false;
  bool isCancelled = false;

  @override
  void initState() {
    super.initState();
    if (widget.status == 'Approved') {
      isApproved = true;
    } else if (widget.status == 'Cancelled') {
      isCancelled = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: AppConatinerDecoration(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  UserImage(imageUrl: '', height: 40),
                  horizontalSpace(10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name ?? "",
                        style: AppStylesManger.font15BoldBlack,
                      ),
                      Text(
                        'Flutter Developer',
                        style: AppStylesManger.font15BoldBlack
                            .copyWith(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  if (widget.status == 'Cancelled' || isCancelled)
                    Row(
                      children: [
                        const Icon(Icons.close, color: Colors.red),
                        Text('Cancelled'.tr(context: context),
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  if (widget.status == 'Approved' || isApproved)
                    Row(
                      children: [
                        const Icon(Icons.check, color: Colors.green),
                        Text('Approved'.tr(context: context),
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  if (widget.status == 'Pending' && !isCancelled && !isApproved)
                    Row(
                      children: [
                        const Icon(Icons.watch_later, color: Colors.orange),
                        Text('Pending'.tr(context: context),
                            style: const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                ],
              ),
            ),
            verticalSpace(10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(children: [
                Text(
                    '${"From".tr(context: context)}: ${widget.from} \n${"To".tr(context: context)}: ${widget.to}',
                    style: AppStylesManger.font15regulerGrey
                        .copyWith(height: 1.5, color: Colors.black54)),
                const Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: Text(
                    '${"Reason".tr(context: context)}: ${widget.reason}',
                    style: AppStylesManger.font15regulerGrey
                      ..copyWith(height: 1.5, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ]),
            ),
            verticalSpace(9),
            if (widget.type == 'Icident')
              widget.employeeId == widget.createdBy
                  ? Text('He is Created This Request'.tr(context: context),
                      style: AppStylesManger.font15regulerGrey)
                  : Text(
                      'Request Created By Anther Employee'.tr(context: context),
                      style: AppStylesManger.font15regulerGrey),
            verticalSpace(5),
            if (widget.status == 'Pending' && !isCancelled && !isApproved)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: RequestButton(
                      text: Text(
                        'Approve'.tr(context: context),
                        style: AppStylesManger.font14regularWhite.copyWith(
                            color: Colors.green[900],
                            fontWeight: FontWeight.bold),
                      ),
                      color: Colors.green[200]!,
                      onPressed: () {
                        approveOrCancelLeaveRequest('Approved', context,
                            widget.userToken ?? "", widget.name ?? "");
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
                            widget.userToken ?? "", widget.name ?? "");
                      },
                    ),
                  ),
                ],
              )
          ],
        ),
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

    BlocProvider.of<LeaveApplicationCubitSupervisor>(context)
        .approveOrRejectLeaveRequest(status: action, id: widget.id);
    getIt<NotificationRepo>().sendSingleNotification(
        token: userToken,
        title: 'Hi, $userName'.tr(context: context),
        body: 'your leave request has been $action'.tr(context: context));
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
