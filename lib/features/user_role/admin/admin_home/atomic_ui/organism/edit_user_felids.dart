import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/enitities/user_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../controllers/branch_cubit/branch_cubit.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../molecules/select_department.dart';
import 'edit_user_data_bloc_listener.dart';

class EditUserFelids extends StatefulWidget {
  const EditUserFelids({
    super.key,
    required this.userItemEntity,
  });
  final UserItemEntity userItemEntity;
  @override
  State<EditUserFelids> createState() => _EditUserFelidsState();
}

class _EditUserFelidsState extends State<EditUserFelids> {
  late TextEditingController editNameController;
  late TextEditingController editUsernameController;
  late TextEditingController editPasswordController;
  late TextEditingController editPositionController;
  late TextEditingController mobileIdController;
  late TextEditingController passwordController;
  String? branch;
  int? branchId;
  String? role;

  @override
  void initState() {
    editNameController =
        BlocProvider.of<EmployeeCubit>(context).editNameController;
    editUsernameController =
        BlocProvider.of<EmployeeCubit>(context).editUsernameController;
    editPasswordController =
        BlocProvider.of<EmployeeCubit>(context).editPasswordController;
    editPositionController =
        BlocProvider.of<EmployeeCubit>(context).editPositionController;
    mobileIdController =
        BlocProvider.of<EmployeeCubit>(context).editMobileIdController;
    passwordController =
        BlocProvider.of<EmployeeCubit>(context).editPasswordController;
    super.initState();
    BlocProvider.of<EmployeeCubit>(context).role = widget.userItemEntity.role;
    BlocProvider.of<EmployeeCubit>(context).branchId =
        widget.userItemEntity.branchId;
    branch = widget.userItemEntity.branch;
    branchId = widget.userItemEntity.branchId;
    role = widget.userItemEntity.role;
  }

  @override
  void dispose() {
    editNameController.dispose();
    editUsernameController.dispose();
    editPasswordController.dispose();
    editPositionController.dispose();
    mobileIdController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        verticalSpace(20),
        Text('Edit name'.tr(),
            style: AppStylesManger.font15BoldBlack),
        verticalSpace(10),
        CustomAppTextFormField(
            controller: editNameController..text = widget.userItemEntity.name,
            hint: 'Edit Name'.tr()),
        Text(' User name'.tr(),
            style: AppStylesManger.font15BoldBlack),
        verticalSpace(10),
        CustomAppTextFormField(
            readOnly: true,
            controller: editUsernameController
              ..text = widget.userItemEntity.userName,
            hint: 'Edit User Name'.tr()),
        verticalSpace(10),
        Text('Edit Position'.tr(),
            style: AppStylesManger.font15BoldBlack),
        verticalSpace(10),
        CustomAppTextFormField(
            controller: editPositionController
              ..text = widget.userItemEntity.position,
            hint: 'Edit User Position'.tr()),
        verticalSpace(10),
        Row(
          children: [
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit Department'.tr(),
                    style: AppStylesManger.font15BoldBlack),
                verticalSpace(10),
                SelectDepartment(
                  department: widget.userItemEntity.department,
                  departmentId: widget.userItemEntity.departmentId,
                ),
              ],
            )),
            horizontalSpace(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Edit Branch'.tr(),
                      style: AppStylesManger.font15BoldBlack),
                  verticalSpace(10),
                  BlocBuilder<BranchCubit, BranchState>(
                    buildWhen: (state, current) =>
                        current is GetBranchSuccess ||
                        current is GetBranchLoading ||
                        current is GetBranchError,
                    builder: (context, state) {
                      if (state is GetBranchLoading) {
                        return Center(
                            child: Skeletonizer(
                                child: Text(
                          'Loading',
                          style: AppStylesManger.font15BoldBlack,
                        )));
                      } else if (state is GetBranchSuccess) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10)),
                          child: DropdownButton(
                            value: branch ?? widget.userItemEntity.department,
                            hint: Text(
                              'Select Branch'.tr(),
                            ),
                            isExpanded: true,
                            icon: SizedBox(
                              height: 24,
                              width: 24,
                              child: Center(
                                child: SvgPicture.asset(
                                    'assets/images/arrow_down.svg',
                                    color: Colors.black),
                              ),
                            ),
                            dropdownColor: Colors.white,
                            iconSize: 24,
                            elevation: 16,
                            underline: const SizedBox(),
                            onChanged: (value) {
                              setState(() {
                                branch = value.toString();
                                branchId = state.branches.data!
                                    .firstWhere(
                                        (element) => element.name == branch)
                                    .id;

                                BlocProvider.of<EmployeeCubit>(context)
                                    .branchId = branchId!;
                              });
                            },
                            items: state.branches.data!
                                .map((e) => DropdownMenuItem(
                                      value: e.name,
                                      child: Text(e.name ?? ""),
                                    ))
                                .toList(),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        verticalSpace(10),
        Row(children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit Role'.tr(),
                    style: AppStylesManger.font15BoldBlack),
                verticalSpace(10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton(
                    value: role ?? widget.userItemEntity.role,
                    isExpanded: true,
                    hint: Text(
                      'Select Role'.tr(),
                    ),
                    icon: SizedBox(
                      height: 24,
                      width: 24,
                      child: Center(
                        child: SvgPicture.asset('assets/images/arrow_down.svg',
                            color: Colors.black),
                      ),
                    ),
                    dropdownColor: Colors.white,
                    iconSize: 24,
                    elevation: 16,
                    underline: const SizedBox(),
                    onChanged: (value) {
                      setState(() {
                        role = value.toString();
                      });
                      BlocProvider.of<EmployeeCubit>(context).role = role!;
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'Admin',
                        child: Text('Admin'.tr()),
                      ),
                      DropdownMenuItem(
                        value: 'Supervisor',
                        child: Text('Supervisor'.tr()),
                      ),
                      DropdownMenuItem(
                        value: 'Employee',
                        child: Text('Employee'.tr()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(7),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Edit MobileID'.tr(),
                    style: AppStylesManger.font15BoldBlack),
                verticalSpace(10),
                CustomAppTextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "MobileID can't be empty".tr();
                    }
                    return null;
                  },
                  controller: mobileIdController
                    ..text = widget.userItemEntity.mobileId,
                  hint: 'MobileID'.tr(),
                ),
              ],
            ),
          ),
        ]),
        verticalSpace(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: CustomAppButton(
            onPressed: () {
              context
                  .read<EmployeeCubit>()
                  .editEmployee(
                    id: widget.userItemEntity.userId,
                  )
                  .then((value) {
                Navigator.pop(context);
              });
            },
            textButton: 'Save'.tr(),
            buttonColor: ColorsManger.primaryColor,
          ),
        ),
        const EditUserDataBlocListener(),
      ],
    );
  }
}
