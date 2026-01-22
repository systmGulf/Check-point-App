import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../atoms/user_item_list_view.dart';

class GetAllEmployeesLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const GetAllEmployeesLoadingSkeleton({
    super.key,
    this.itemCount = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: Column(
        children: [
          Row(
            children: [
              Text('Users List'.tr(context: context),
                  style: AppStylesManger.font15BoldBlack),
              const Spacer(),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ],
          ),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: itemCount,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: UserItemListView(
                  userId: ' ',
                  userName: 'data loading',
                  department: 'data loading',
                  mobileId: 'data loading',
                  role: 'data loading',
                  departmentId: 00,
                  branch: 'data loading',
                  branchId: 00,
                  imageUrl: 'data loading',
                  shiftName: 'data loading',
                  shiftEndTime: 'data loading',
                  shiftStartTime: 'data loading',
                  name: 'data loading',
                  position: 'data loading',
                  onDelete: () {},
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
