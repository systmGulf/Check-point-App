import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../atoms/user_item_list_view.dart';

class AllUsersListLoadingSkeleton extends StatelessWidget {
  final int itemCount;

  const AllUsersListLoadingSkeleton({
    super.key,
    this.itemCount = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView(
        children: [
          Row(
            children: [
              Text('Users List'.tr(context: context),
                  style: AppStylesManger.font15BoldBlack),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: ColorsManger.primaryColor),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    '0',
                    style: AppStylesManger.font14regularWhite,
                  ),
                ),
              )
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
