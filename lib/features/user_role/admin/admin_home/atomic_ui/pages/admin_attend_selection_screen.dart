import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/routing/routes.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/mange_employee_cubit/employee_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:flutter_svg/svg.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:employee_mangement/core/widgets/custom_app_text_form_field.dart';

class AdminAttendSelectionScreen extends StatefulWidget {
  const AdminAttendSelectionScreen({super.key});

  @override
  State<AdminAttendSelectionScreen> createState() =>
      _AdminAttendSelectionScreenState();
}

class _AdminAttendSelectionScreenState
    extends State<AdminAttendSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, 'Select Employee'.tr()),
      body: Column(
        children: [
          verticalSpace(16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: CustomAppTextFormField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                context.read<EmployeeCubit>().searchEmployee(name: value);
              },
              hint: "Search employee...".tr(),
              prefixIcon: Padding(
                padding: const EdgeInsets.all(12.0),
                child: SvgPicture.asset(
                  Assets.SearchIconImage,
                  height: 20,
                  width: 20,
                ),
              ),
            ),
          ),
          verticalSpace(16),
          Expanded(
            child: BlocBuilder<EmployeeCubit, EmployeeState>(
              buildWhen: (previous, current) =>
                  current is GetAllEmployeesLoading ||
                  current is GetAllEmployeesSuccess ||
                  current is GetAllEmployeesFailure ||
                  current is SearchEmployeeLoading ||
                  current is SearchEmployeeSuccess ||
                  current is SearchEmployeeFailure,
              builder: (context, state) {
                if (state is GetAllEmployeesLoading || state is SearchEmployeeLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is GetAllEmployeesFailure) {
                  return Center(child: Text(state.error));
                } else if (state is SearchEmployeeFailure) {
                  return Center(child: Text(state.error));
                }

                List<EmployeeData> employees = [];
                if (_searchQuery.isNotEmpty) {
                  if (state is SearchEmployeeSuccess) {
                    employees = state.employeeList.data ?? [];
                  }
                } else {
                  if (state is GetAllEmployeesSuccess) {
                    employees = state.value.data ?? [];
                  }
                }

                if (employees.isEmpty) {
                  return const Center(child: NoDataFound());
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: employees.length,
                  itemBuilder: (context, index) {
                    final employee = employees[index];
                    return Card(
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        leading: UserImage(
                          imageUrl: employee.imageUrl,
                          height: 40,
                        ),
                        title: Text(
                          employee.name ?? employee.userName ?? '',
                          style: AppStylesManger.font15BoldBlue
                              .copyWith(color: Colors.black),
                        ),
                        subtitle: Text(
                          employee.position ?? '',
                          style: AppStylesManger.font14RegularBlack.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: ColorsManger.primaryColor,
                        ),
                        onTap: () {
                          context.pushName(
                            Routes.supervisorAttendSomeEmployeeScreen,
                            arguments: employee,
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
