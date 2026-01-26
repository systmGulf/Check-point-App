import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/atoms/admin_notification_item.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class AdminNotificationItemLoad extends StatelessWidget {
  const AdminNotificationItemLoad({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
        child: AdminNotificationItem(
            name: 'Data loading',
            mobileId: 'Data loading',
            onTap: () {},
            id: 00,
            date: DateTime(2023, 01, 01)));
  }
}
