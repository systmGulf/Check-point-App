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
  final String from, to, reason, status, type;
  final int id;

  @override
  Widget build(BuildContext context) {
    final Color statusColor = status == 'Approved'.tr()
        ? Colors.green
        : status == 'Cancelled'.tr()
            ? Colors.red
            : Colors.orange;
    final IconData statusIcon = status == 'Approved'.tr()
        ? Icons.check_circle
        : status == 'Cancelled'.tr()
            ? Icons.cancel
            : Icons.hourglass_empty;

    return Container(
      decoration: AppContainerDecoration(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request'.tr(),
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${"from".tr()}: $from',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${"To".tr()}: $to',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${"Reason".tr()} : $reason',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        '${"Status".tr()}: ',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      horizontalSpace(6),
                      Icon(
                        statusIcon,
                        color: statusColor,
                        size: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () {
                BlocProvider.of<LeaveApplicationCubit>(context).deleteLeaveRequest(
                  type: type,
                  id: id,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.red,
                  ),
                ),
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 22,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
