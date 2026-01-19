import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/atoms/taks_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../pages/edit_user_screen.dart';

class UserItemGridView extends StatelessWidget {
  const UserItemGridView(
      {super.key,
      required this.name,
      required this.position,
      required this.userId,
      required this.department,
      required this.userName,
      required this.mobileId,
      required this.role,
      required this.branch,
      required this.departmentId,
      required this.branchId,
      required this.userImage});
  final String name,
      position,
      userId,
      department,
      userName,
      mobileId,
      role,
      branch;
  final int departmentId, branchId;
  final String userImage;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 10,
        ),
        height: 120.h,
        decoration: AppConatinerDecoration(),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          UserImage(height: 50, imageUrl: userImage),
          verticalSpace(20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.35,
            child: Column(
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
                ]))
              ],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                      height: 24,
                      width: 24,
                      child: Center(
                          child: SvgPicture.asset('assets/images/edit.svg'))),
                  color: Colors.blue,
                ),
                horizontalSpace(0),
                IconButton(
                  onPressed: () {
                    buildDeleteAlertDialog(context,
                        title: 'Delete User'.tr(context: context),
                        message: 'Are you sure you want to delete this user?'
                            .tr(context: context), onYes: () {
                      context.pop();
                      BlocProvider.of<EmployeeCubit>(context)
                          .deleteUserAccount(userId: userId);
                    });
                  },
                  icon: SizedBox(
                      height: 24,
                      width: 24,
                      child: Center(
                          child: SvgPicture.asset(
                              'assets/images/delete_icon.svg'))),
                ),
              ],
            ),
          ),
        ]));
  }
}
