import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/admin/admin_data.dart';
import 'package:hr_management_system_package/admin/data/repo/department_repo/department_repo.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../controllers/branch_cubit/branch_cubit.dart';
import '../../controllers/department_cubit/department_cubit.dart';
import '../organism/edit_user_felids.dart';

class EditUser extends StatefulWidget {
  const EditUser(
      {super.key,
      required this.name,
      required this.userName,
      required this.position,
      required this.department,
      required this.id,
      required this.mobileId,
      required this.role,
      required this.departmentId,
      required this.branch,
      required this.branchId});
  final String name, userName, position, department, id, mobileId, role, branch;
  final int departmentId, branchId;

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DepartmentCubit(
            getIt<DepartmentRepo>(),
          )..getAllDepartments(),
        ),
        BlocProvider(
            create: (context) => BranchCubit(
                  getIt<BranchesRepo>(),
                )..getBranches()),
      ],
      child: Scaffold(
        appBar: buildCustomAppBar(
          context,
          'Edit User'.tr(context: context),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: EditUserFelids(
              branchId: widget.branchId,
              branch: widget.branch,
              departmentId: widget.departmentId,
              name: widget.name,
              userName: widget.userName,
              position: widget.position,
              department: widget.department,
              id: widget.id,
              mobileId: widget.mobileId,
              role: widget.role,
            ),
          ),
        ),
      ),
    );
  }
}
