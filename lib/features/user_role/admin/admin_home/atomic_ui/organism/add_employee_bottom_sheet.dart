import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/admin/data/repo/department_repo/department_repo.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../../../../../core/widgets/custom_app_text_form_field.dart';
import '../../controllers/branch_cubit/branch_cubit.dart';
import '../../controllers/department_cubit/department_cubit.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../molecules/select_department.dart';
import 'add_employee_bloc_listener.dart';

class AddEmployeeBottomSheet extends StatefulWidget {
  const AddEmployeeBottomSheet({
    super.key,
    this.name,
    this.deviceToken,
    this.mobileId,
    this.requestId,
  });
  final String? name, deviceToken, mobileId;
  final int? requestId;
  @override
  State<AddEmployeeBottomSheet> createState() => _AddEmployeeBottomSheetState();
}

class _AddEmployeeBottomSheetState extends State<AddEmployeeBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController mobileIdController;

  String role = 'Employee';
  String? branch;
  int? branchId;
  @override
  void initState() {
    nameController = BlocProvider.of<EmployeeCubit>(context).nameController
      ..text = widget.name ?? '';

    BlocProvider.of<EmployeeCubit>(context).usernameController =
        TextEditingController();

    BlocProvider.of<EmployeeCubit>(context).passwordController =
        TextEditingController();

    BlocProvider.of<EmployeeCubit>(context).positionController =
        TextEditingController();
    mobileIdController = BlocProvider.of<EmployeeCubit>(context)
        .mobileIdController
      ..text = widget.mobileId ?? '';
    super.initState();
  }

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
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Form(
          key: _formKey,
          child: IntrinsicHeight(
            child: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(20),
                    )),
                child: Center(
                  child: Column(
                    children: [
                      SizedBox(
                        child: Text(
                          'New User'.tr(context: context),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: ColorsManger.primaryColor,
                              fontSize: 16),
                        ),
                      ),
                      verticalSpace(7),
                      CustomAppTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Name can't be empty".tr(context: context);
                          }
                          return null;
                        },
                        controller: nameController,
                        hint: 'Name'.tr(context: context),
                      ),
                      verticalSpace(7),
                      CustomAppTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Username can't be empty"
                                .tr(context: context);
                          }
                          return null;
                        },
                        controller: BlocProvider.of<EmployeeCubit>(context)
                            .usernameController,
                        hint: 'Username'.tr(context: context),
                      ),
                      verticalSpace(7),
                      CustomAppTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password can't be empty"
                                .tr(context: context);
                          }
                          return null;
                        },
                        controller: BlocProvider.of<EmployeeCubit>(context)
                            .passwordController,
                        hint: 'Password'.tr(context: context),
                      ),
                      verticalSpace(7),
                      CustomAppTextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Position can't be empty"
                                .tr(context: context);
                          }
                          return null;
                        },
                        controller: BlocProvider.of<EmployeeCubit>(context)
                            .positionController,
                        hint: 'Position'.tr(context: context),
                      ),
                      verticalSpace(7),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      color: ColorsManger.primaryColor),
                                  borderRadius: BorderRadius.circular(10)),
                              child: DropdownButton(
                                isExpanded: true,
                                value: role,
                                icon: const Icon(Icons.keyboard_arrow_down),
                                dropdownColor: Colors.white,
                                iconSize: 24,
                                elevation: 16,
                                underline: const SizedBox(),
                                onChanged: (value) {
                                  setState(() {
                                    role = value.toString();
                                  });
                                  BlocProvider.of<EmployeeCubit>(context).role =
                                      value.toString();
                                },
                                items: [
                                  DropdownMenuItem(
                                    value: 'Admin',
                                    child: Text('Admin'.tr(context: context)),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Supervisor',
                                    child:
                                        Text('Supervisor'.tr(context: context)),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Employee',
                                    child:
                                        Text('Employee'.tr(context: context)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          horizontalSpace(7),
                          Expanded(
                            child: CustomAppTextFormField(
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "MobileID can't be empty"
                                      .tr(context: context);
                                }
                                return null;
                              },
                              controller: mobileIdController,
                              hint: 'MobileID'.tr(context: context),
                            ),
                          ),
                        ],
                      ),
                      Divider(
                        thickness: 1,
                        color: ColorsManger.lightblack,
                      ),
                      verticalSpace(7),
                      const SelectDepartment(),
                      verticalSpace(7),
                      BlocBuilder<BranchCubit, BranchState>(
                          buildWhen: (state, current) =>
                              current is GetBranchSuccess ||
                              current is GetBranchLoading ||
                              current is GetBranchError,
                          builder: (context, state) {
                            if (state is GetBranchLoading) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (state is GetBranchSuccess) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: ColorsManger.primaryColor),
                                    borderRadius: BorderRadius.circular(10)),
                                child: DropdownButton(
                                  hint: Text(
                                    'Select Branch'.tr(context: context),
                                  ),
                                  isExpanded: true,
                                  icon: const Icon(Icons.keyboard_arrow_down),
                                  dropdownColor: Colors.white,
                                  iconSize: 24,
                                  value: branch,
                                  elevation: 16,
                                  underline: const SizedBox(),
                                  onChanged: (value) {
                                    print(value);
                                    setState(() {
                                      branch = value.toString();
                                      branchId = state.branches.data!
                                          .firstWhere((element) =>
                                              element.name == branch)
                                          .id;
                                      print(branchId);
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
                          }),
                      verticalSpace(7),
                      CustomAppButton(
                          textButton: 'Submit'.tr(context: context),
                          buttonColor: ColorsManger.primaryColor,
                          onPressed: () {
                            validateAndAddUser(role: role);
                          }),
                      AddEmployeeBlocListener(
                        requestId: widget.requestId ?? 0,
                        userName: context
                            .read<EmployeeCubit>()
                            .usernameController
                            .text,
                        password: context
                            .read<EmployeeCubit>()
                            .passwordController
                            .text,
                        deviceToken: widget.deviceToken ?? '',
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  validateAndAddUser({
    required String role,
  }) {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<EmployeeCubit>(context).addEmployee(role: role);
    }
  }
}
