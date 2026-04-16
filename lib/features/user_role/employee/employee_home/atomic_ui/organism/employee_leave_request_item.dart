import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/common/app_container_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../controller/leave_application/leave_application_cubit.dart';

class EmployeeLeaveRequestItem extends StatelessWidget {
  const EmployeeLeaveRequestItem({
    super.key,
    required this.from,
    required this.to,
    required this.reason,
    required this.status,
    required this.id,
    required this.type,
  });
  final String from, to, reason, type;
  final int status;
  final String id;

  String _statusText(BuildContext context) {
    switch (status) {
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

  Color _statusColor() {
    switch (status) {
      case 1:
        return Colors.green;
      case 2:
      case 3:
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  IconData _statusIcon() {
    switch (status) {
      case 1:
        return Icons.check_circle;
      case 2:
      case 3:
        return Icons.cancel;
      default:
        return Icons.hourglass_empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppContainerDecoration(),
      child: ListTile(
        title: Text(
          '${"Request".tr(context: context)}  \n${"from".tr(context: context)}: $from\n${"To".tr(context: context)}: $to',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 5),
            SizedBox(
              child: Text(
                '${"Reason".tr(context: context)}  : $reason',
                style: TextStyle(color: Colors.grey[600]),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Text(
                  '${"Status".tr(context: context)}: ',
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  _statusText(context),
                  style:
                      TextStyle(color: _statusColor(), fontWeight: FontWeight.bold),
                ),
                horizontalSpace(4),
                Icon(
                  _statusIcon(),
                  color: _statusColor(),
                )
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: Colors.red,
                      )),
                  child: const Icon(Icons.close, color: Colors.red)),
              onPressed: () {
                final parsedId = int.tryParse(id);
                if (parsedId == null) return;
                BlocProvider.of<LeaveApplicationCubit>(context)
                    .deleteLeaveRequest(
                  type: type,
                  id: parsedId,
                );
              },
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
