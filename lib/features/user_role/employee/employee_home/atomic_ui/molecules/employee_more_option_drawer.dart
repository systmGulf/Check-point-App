import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../organism/employee_more_option_list_view.dart';

class EmployeeMoreOptionDrawer extends StatelessWidget {
  const EmployeeMoreOptionDrawer({super.key, this.isSupervisor = false});

  final bool isSupervisor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
              child: Column(
            children: [
              verticalSpace(50),
              SizedBox(
                  height: 100.h,
                  child: Image.asset('assets/images/vodaphone.png')),
              MoreOptionDrawerListView(isSupervisor: isSupervisor),
            ],
          )),
        ],
      ),
    );
  }
}
