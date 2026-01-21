import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/common/app_container_decoration.dart';
import '../../../../../../core/styles/colors.dart';

class ClientInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;

  const ClientInfoTile({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: AppContainerDecoration(),
      child: ListTile(
        leading: Icon(icon, color: ColorsManger.primaryColor),
        title: Text(title),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
