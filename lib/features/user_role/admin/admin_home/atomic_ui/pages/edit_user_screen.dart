import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/enitities/user_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../controllers/branch_cubit/branch_cubit.dart';
import '../../controllers/department_cubit/department_cubit.dart';
import '../organism/edit_user_felids.dart';

class EditUser extends StatefulWidget {
  const EditUser({
    super.key,
    required this.userItemEntity,
  });
  final UserItemEntity userItemEntity;

  @override
  State<EditUser> createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {
  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => DepartmentCubit(
            departmentRepo: getIt<DepartmentRepo>(),
          )..getAllDepartments(),
        ),
        BlocProvider(
            create: (context) => BranchCubit(
                  branchesRepo: getIt<BranchesRepo>(),
                )..getBranches(
                    isLoading: true,
                  )),
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
              userItemEntity: widget.userItemEntity,
            ),
          ),
        ),
      ),
    );
  }
}
