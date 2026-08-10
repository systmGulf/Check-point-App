import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/atoms/leave_application_item.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/molecules/recent_leave_application_loading_skeleton.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';
import 'package:employee_mangement/core/widgets/build_snake_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart' as top_snackbar;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/core/notifications/notification_repo.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/error_widget.dart';
import '../../controllers/admin_leave_requests_cubit/admin_leave_requests_cubit.dart';

class AdminLeavesScreen extends StatelessWidget {
  const AdminLeavesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<AdminLeaveRequestsCubit>()..getAllLeaveRequests(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Leaves'.tr(),
            style: AppStylesManger.font18BoldBlack,
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: const AdminLeavesScreenBody(),
      ),
    );
  }
}

class AdminLeavesScreenBody extends StatelessWidget {
  const AdminLeavesScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        BlocProvider.of<AdminLeaveRequestsCubit>(context).getAllLeaveRequests();
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: BlocConsumer<AdminLeaveRequestsCubit, AdminLeaveRequestsState>(
          listener: (context, state) {
            if (state is DeleteAdminLeaveRequestSuccess) {
              buildSnackBar(
                context,
                customSnackBar: top_snackbar.CustomSnackBar.success(
                  message: 'Request deleted successfully'.tr(),
                ),
              );
            } else if (state is DeleteAdminLeaveRequestFailure) {
              buildSnackBar(
                context,
                customSnackBar: top_snackbar.CustomSnackBar.error(
                  message: state.error,
                ),
              );
            }
          },
          buildWhen: (previous, current) =>
              current is GetAllLeaveRequestsSuccess ||
              current is GetAllLeaveRequestsFailure ||
              current is GetAllLeaveRequestsLoading,
          builder: (context, state) {
            if (state is GetAllLeaveRequestsFailure) {
              return CustomErrorWidget(
                error: state.error,
                onRetry: () {
                  BlocProvider.of<AdminLeaveRequestsCubit>(context)
                      .getAllLeaveRequests();
                },
              );
            }
            if (state is GetAllLeaveRequestsSuccess) {
              final leaveRequests =
                  state.getLeaveRequestModel.value?.data ?? [];
              if (leaveRequests.isEmpty) {
                return const Center(child: NoDataFound());
              }
              final pendingCount =
                  leaveRequests.where((e) => e.status == 'Pending').length;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '${"There are".tr()} $pendingCount ${"Pending Leave Requests".tr()}',
                        style: AppStylesManger.font15BoldBlack,
                      ),
                      horizontalSpace(10),
                      Badge.count(
                        backgroundColor: Colors.red,
                        count: pendingCount,
                        child: Icon(Icons.notifications_on,
                            color: Colors.grey.shade400),
                      )
                    ],
                  ),
                  verticalSpace(15),
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: leaveRequests.length,
                    itemBuilder: (context, index) {
                      final item = leaveRequests[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ElasticInUp(
                          child: AdminLeaveItem(
                            id: item.id ?? 0,
                            name: item.employee?.userName ??
                                item.employee?.name ??
                                'Employee',
                            userToken:
                                item.employee?.deviceTokens?.isNotEmpty == true
                                    ? item.employee!.deviceTokens!.first
                                    : '',
                            position: item.employee?.position ?? '',
                            department: item.employee?.departmentName ?? '',
                            role: item.employee?.role ?? '',
                            from: item.startDate ?? '',
                            to: item.endDate ?? '',
                            reason: item.reason ?? '',
                            status: item.status ?? '',
                            leaveType: item.leaveRequestType ?? '',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            }
            return const RecentLeaveApplicationLoadingSkeleton();
          },
        ),
      ),
    );
  }
}

class AdminLeaveItem extends StatefulWidget {
  final int id;
  final String name;
  final String userToken;
  final String position;
  final String department;
  final String role;
  final String from;
  final String to;
  final String reason;
  final String status;
  final String leaveType;

  const AdminLeaveItem({
    super.key,
    required this.id,
    required this.name,
    required this.userToken,
    required this.position,
    required this.department,
    required this.role,
    required this.from,
    required this.to,
    required this.reason,
    required this.status,
    required this.leaveType,
  });

  @override
  State<AdminLeaveItem> createState() => _AdminLeaveItemState();
}

class _AdminLeaveItemState extends State<AdminLeaveItem> {
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
    DateFormat dateFormat = DateFormat(
        tr('date_format', context: context), context.locale.toString());

    String formattedFrom = widget.from;
    String formattedTo = widget.to;
    try {
      if (widget.from.isNotEmpty) {
        formattedFrom = dateFormat.format(DateTime.parse(widget.from));
      }
      if (widget.to.isNotEmpty) {
        formattedTo = dateFormat.format(DateTime.parse(widget.to));
      }
    } catch (_) {}

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: AppContainerDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const UserImage(imageUrl: '', height: 40),
              horizontalSpace(10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.name,
                            style: AppStylesManger.font15BoldBlack,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (widget.role.isNotEmpty) ...[
                          horizontalSpace(6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: widget.role
                                      .toLowerCase()
                                      .contains('supervisor')
                                  ? Colors.purple.withAlpha(30)
                                  : Colors.blue.withAlpha(30),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: widget.role
                                        .toLowerCase()
                                        .contains('supervisor')
                                    ? Colors.purple.withAlpha(80)
                                    : Colors.blue.withAlpha(80),
                                width: 0.5,
                              ),
                            ),
                            child: Text(
                              widget.role.tr(),
                              style: TextStyle(
                                color: widget.role
                                        .toLowerCase()
                                        .contains('supervisor')
                                    ? Colors.purple[800]
                                    : Colors.blue[800],
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (widget.department.isNotEmpty ||
                        widget.position.isNotEmpty)
                      Text(
                        '${widget.department.isNotEmpty ? widget.department : ''} ${widget.position.isNotEmpty ? "(${widget.position})" : ''}',
                        style: AppStylesManger.font15BoldBlack
                            .copyWith(color: Colors.grey, fontSize: 12),
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              horizontalSpace(6),
              if (widget.status == 'Cancelled' || isCancelled)
                Row(
                  children: [
                    const Icon(Icons.close, color: Colors.red, size: 18),
                    horizontalSpace(4),
                    Text('Cancelled'.tr(),
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
              if (widget.status == 'Approved' || isApproved)
                Row(
                  children: [
                    const Icon(Icons.check, color: Colors.green, size: 18),
                    horizontalSpace(4),
                    Text('Approved'.tr(),
                        style: const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)),
                  ],
                ),
              if (widget.status == 'Pending' && !isCancelled && !isApproved)
                Row(
                  children: [
                    const Icon(Icons.watch_later,
                        color: Colors.orange, size: 18),
                    horizontalSpace(4),
                    Text('Pending'.tr(),
                        style: const TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold)),
                  ],
                ),
              horizontalSpace(6),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.delete_outline,
                    color: Colors.red, size: 20),
                onPressed: () => _confirmDelete(context),
              ),
            ],
          ),
          verticalSpace(10),
          if (widget.leaveType.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: ColorsManger.primaryColor.withAlpha(25),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  widget.leaveType.tr(),
                  style: AppStylesManger.font15BoldBlack.copyWith(
                    color: ColorsManger.primaryColor,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${"From".tr()}: $formattedFrom\n${"To".tr()}: $formattedTo',
                  style: AppStylesManger.font15regulerGrey
                      .copyWith(height: 1.5, color: Colors.black54),
                ),
              ),
              if (widget.reason.isNotEmpty)
                Expanded(
                  child: Text(
                    '${"Reason".tr()}: ${widget.reason}',
                    style: AppStylesManger.font15regulerGrey
                        .copyWith(height: 1.5, color: Colors.black),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
            ],
          ),
          if (widget.status == 'Pending' && !isCancelled && !isApproved) ...[
            verticalSpace(10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: RequestButton(
                    text: Text(
                      'Approve'.tr(),
                      style: AppStylesManger.font14regularWhite.copyWith(
                          color: Colors.green[900],
                          fontWeight: FontWeight.bold),
                    ),
                    color: Colors.green[200]!,
                    onPressed: () {
                      _approveOrReject('Approved');
                    },
                  ),
                ),
                horizontalSpace(10),
                Expanded(
                  child: RequestButton(
                    text: Text(
                      'Reject'.tr(),
                      style: AppStylesManger.font14RedularRed,
                    ),
                    color: Colors.red[200]!,
                    onPressed: () {
                      _approveOrReject('Cancelled');
                    },
                  ),
                ),
              ],
            )
          ]
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Delete Request'.tr()),
        content: Text('Are you sure you want to delete this request?'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('Cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              BlocProvider.of<AdminLeaveRequestsCubit>(context)
                  .deleteLeaveRequest(id: widget.id);
            },
            child: Text(
              'Delete'.tr(),
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _approveOrReject(String action) {
    setState(() {
      if (action == 'Approved') {
        isApproved = true;
        isCancelled = false;
      } else {
        isApproved = false;
        isCancelled = true;
      }
    });

    BlocProvider.of<AdminLeaveRequestsCubit>(context)
        .approveOrRejectLeaveRequest(status: action, id: widget.id);

    if (widget.userToken.isNotEmpty) {
      getIt<NotificationRepo>().sendSingleNotification(
        token: widget.userToken,
        title: 'Hi, ${widget.name}'.tr(),
        body: 'your leave request has been $action'.tr(),
      );
    }
  }
}
