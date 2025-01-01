import 'package:easy_localization/easy_localization.dart';
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
  final String from, to, reason, status, type;
  final int id;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.grey)),
      color: Colors.white,
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
                Text(status,
                    style: status == 'Approved'.tr(context: context)
                        ? const TextStyle(
                            color: Colors.green, fontWeight: FontWeight.bold)
                        : status == 'Cancelled'.tr(context: context)
                            ? const TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold)
                            : const TextStyle(
                                color: Colors.orange,
                                fontWeight: FontWeight.bold)),
                horizontalSpace(4),
                Icon(
                  status == 'Approved'.tr(context: context)
                      ? Icons.check_circle
                      : status == 'Cancelled'.tr(context: context)
                          ? Icons.cancel
                          : Icons.hourglass_empty,
                  color: status == 'Approved'.tr(context: context)
                      ? Colors.green
                      : status == 'Cancelled'.tr(context: context)
                          ? Colors.red
                          : Colors.orange,
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
                BlocProvider.of<LeaveApplicationCubit>(context)
                    .deleteLeaveRequest(
                  type: type,
                  id: id,
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
