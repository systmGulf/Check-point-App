import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:flutter/material.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class EmployeeCard extends StatelessWidget {
  const EmployeeCard({
    super.key,
    required this.employeeName,
    required this.date, required this.imageUrl,
  });
  final String employeeName, date;
  final String imageUrl ;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: ColorsManger.primaryColor,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Column(
          children: [
            verticalSpace(14),
            UserImage(height: 80, imageUrl: imageUrl,),
            verticalSpace(10),
            Text(
              employeeName,
              style: AppStylesManger.font21regulerWhite,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              date,
              style: AppStylesManger.font21regulerWhite,
            ),
            verticalSpace(20),
          ],
        ),
      ),
    );
  }
}
