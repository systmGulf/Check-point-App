import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../pages/edit_user_screen.dart';

class UserItemListView extends StatelessWidget {
  const UserItemListView(
      {super.key,
      required this.name,
      required this.position,
      required this.userId,
      required this.department,
      required this.userName,
      required this.mobileId,
      required this.role,
      required this.departmentId,
      required this.branch,
      required this.branchId,
      required this.onDelete,
      required this.imageUrl,
      required this.shiftName,
      required this.shiftStartTime,
      required this.shiftEndTime});
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0XFFFAFAFA),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Row(
        children: [
          UserImage(height: 50, imageUrl: imageUrl),
          horizontalSpace(20),
          Expanded(
            flex: 4,
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,
                    style: AppStylesManger.font15BoldBlue
                        .copyWith(color: ColorsManger.primaryColor)),
                Text(
                  position,
                  style: AppStylesManger.font14RegularBlack.copyWith(
                      color: const Color.fromARGB(255, 122, 121, 121)),
                  overflow: TextOverflow.ellipsis,
                ),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "${"Team".tr(context: context)} : ",
                      style: AppStylesManger.font14RegularBlack.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 122, 121, 121))),
                  TextSpan(
                      text: department,
                      style: AppStylesManger.font14RegularBlack
                          .copyWith(color: Colors.grey))
                ])),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "${"Shift".tr(context: context)} : ",
                      style: AppStylesManger.font14RegularBlack.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 122, 121, 121))),
                  TextSpan(
                      text: shiftName,
                      style: AppStylesManger.font14RegularBlack
                          .copyWith(color: Colors.grey))
                ])),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "${"clockInTime".tr(context: context)} : ",
                      style: AppStylesManger.font14RegularBlack.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 122, 121, 121))),
                  TextSpan(
                      text: shiftStartTime,
                      style: AppStylesManger.font14RegularBlack
                          .copyWith(color: Colors.grey))
                ])),
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "${"clockOutTime".tr(context: context)} : ",
                      style: AppStylesManger.font14RegularBlack.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 122, 121, 121))),
                  TextSpan(
                      text: shiftEndTime,
                      style: AppStylesManger.font14RegularBlack
                          .copyWith(color: Colors.grey))
                ]))
              ],
            ),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => getIt<EmployeeCubit>(),
                      child: EditUser(
                        branchId: branchId,
                        branch: branch,
                        departmentId: departmentId,
                        mobileId: mobileId,
                        role: role,
                        id: userId,
                        name: name,
                        userName: userName,
                        position: position,
                        department: department,
                      ),
                    );
                  },
                ),
              ).then((value) {
                context
                    .read<EmployeeCubit>()
                    .getAllEmployees(pageNumber: 0, itemCount: 10);
              });
            },
            icon: SizedBox(
              height: 26,
              width: 26,
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/edit.svg',
                  color: ColorsManger.primaryColor,
                ),
              ),
            ),
            color: Colors.blue,
          ),
          horizontalSpace(0),
          IconButton(
            onPressed: onDelete,
            icon: SizedBox(
                height: 24,
                width: 24,
                child: Center(
                    child: SvgPicture.asset('assets/images/delete_icon.svg'))),
            color: Colors.red,
          ),
        ],
      ),
    );
  }
}
