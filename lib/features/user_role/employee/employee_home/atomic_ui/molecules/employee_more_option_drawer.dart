import 'package:flutter/material.dart';

import '../../../../../../core/helpers/app_spaces.dart';
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
              Image.asset('assets/images/app_logo.png'),
              verticalSpace(20),
              const MoreOptionDrawerListView(),
            ],
          )),
        ],
      ),
    );
  }
}
