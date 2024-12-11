import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hr_management_system_package/admin/data/repo/employee_repo/admin_manage_employee_repo.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../pages/edit_user_screen.dart';

class UserItemListView extends StatelessWidget {
  const UserItemListView({
    super.key,
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
  });
  final String name,
      position,
      userId,
      department,
      userName,
      mobileId,
      role,
      branch;
  final int departmentId, branchId;
  final VoidCallback onDelete;

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
          const CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 22,
            backgroundImage: AssetImage('assets/images/icon-default-user.png'),
          ),
          horizontalSpace(20),
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
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return BlocProvider(
                      create: (context) => EmployeeCubit(
                        getIt<AdminManageEmployeeRepo>(),
                      ),
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
                if (!context.mounted) return;
                context.read<EmployeeCubit>().getAllEmployees();
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
