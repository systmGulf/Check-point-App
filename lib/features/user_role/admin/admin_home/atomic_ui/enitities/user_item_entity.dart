import 'package:flutter/widgets.dart';

class UserItemEntity {
  final String name,
      position,
      userId,
      department,
      userName,
      mobileId,
      role,
      branch,
      shiftName,
      shiftStartTime,
      shiftEndTime;
  final int departmentId, branchId;
  final VoidCallback onDelete;
  final String imageUrl;

  UserItemEntity(
      {required this.name,
      required this.position,
      required this.userId,
      required this.department,
      required this.userName,
      required this.mobileId,
      required this.role,
      required this.branch,
      required this.shiftName,
      required this.shiftStartTime,
      required this.shiftEndTime,
      required this.departmentId,
      required this.branchId,
      required this.onDelete,
      required this.imageUrl});
}
