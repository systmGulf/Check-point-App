
import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/molecules/custom_admin_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../atoms/client_item.dart';

class CustomerLoadingSkeleton extends StatelessWidget {
  final VoidCallback onPickExcel;

  const CustomerLoadingSkeleton({Key? key, required this.onPickExcel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        CustomAdminAppBar(onPickExcel: onPickExcel, appBarName: 'Clients',),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) =>  Skeletonizer(
              child: ClientItem(
                onTap:() {},
                onEdit: () {},
                color: Colors.white,
                id: '',
                name: 'Load Data',
                workedAs: 'Load Data',
                location: 'Load Data',
              ),
            ),
            childCount: 10,
          ),
        ),
      ],
    );
  }
}
