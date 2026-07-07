import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/utils/assets_manager.dart';
import '../organism/employee_more_option_list_view.dart';

class EmployeeMoreOptionDrawer extends StatelessWidget {
  const EmployeeMoreOptionDrawer({super.key});

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
                height: 84.h,
                child: Image.asset(
                  Assets.AppLogoImage,
                  fit: BoxFit.contain,
                ),
              ),
              const MoreOptionDrawerListView(),
            ],
          )),
        ],
      ),
    );
  }
}
