import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:employee_mangement/core/widgets/app_action_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import './assign_police_to_employees_loading_skeleton.dart';

class AddEmployeesToPoliceModelBottomSheet extends StatelessWidget {
  const AddEmployeesToPoliceModelBottomSheet(
      {super.key, required this.policeId});
  final int policeId;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: AppActionIconButton.delete(
              onPressed: () {
                context.pop();
              },
              size: 34,
              backgroundColor: Colors.white,
              iconColor: ColorsManger.primaryColor,
            ),
          ),
          verticalSpace(10.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'add employees'.tr(),
              style: AppStylesManger.font14RegularBlack
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          verticalSpace(10.h),
          BlocBuilder<EmployeeCubit, EmployeeState>(
            buildWhen: (previous, current) =>
                current is GetAllEmployeesLoading ||
                current is GetAllEmployeesSuccess ||
                current is GetAllEmployeesFailure,
            builder: (context, state) {
              if (state is GetAllEmployeesLoading) {
                return Center(
                    child: CircularProgressIndicator(
                  color: ColorsManger.primaryColor,
                  strokeWidth: 2,
                  backgroundColor: Colors.white,
                ));
              } else if (state is GetAllEmployeesSuccess) {
                List<DropdownItem<String>> dropdownItems = List.generate(
                    state.value.data!.length,
                    (index) => DropdownItem<String>(
                        label: state.value.data![index].name.toString(),
                        value: state.value.data![index].id.toString()));

                MultiSelectController<String>? controller;
                return MultiDropdown<String>(
                  items: dropdownItems,
                  fieldDecoration: FieldDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'select employees'.tr(),
                  ),
                  controller: controller,
                  enabled: true,
                  searchEnabled: true,
                  closeOnBackButton: true,
                  searchDecoration: SearchFieldDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'Search'.tr(),
                  ),
                  chipDecoration: ChipDecoration(
                      backgroundColor: ColorsManger.primaryColor,
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      wrap: true,
                      runSpacing: 2,
                      spacing: 10,
                      deleteIcon: Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                        size: 15.h,
                      )),
                  onSelectionChange: (selectedItems) {
                    context.read<ShiftsAndPolicesCubit>().employeesIds =
                        List<String>.generate(selectedItems.length,
                            (index) => selectedItems[index]);
                    if (context
                        .read<ShiftsAndPolicesCubit>()
                        .employeesIds
                        .contains(List<String>.generate(selectedItems.length,
                            (index) => selectedItems[index]))) {
                      context.read<ShiftsAndPolicesCubit>().employeesIds.remove(
                          List<String>.generate(selectedItems.length,
                              (index) => selectedItems[index]));
                    }
                  },
                );
              } else if (state is GetAllEmployeesFailure) {
                return const Center(child: Text('Error'));
              }
              return SizedBox.expand();
            },
          ),
          verticalSpace(20),
          BlocConsumer<ShiftsAndPolicesCubit, ShiftsAndPolicesState>(
            buildWhen: (previous, current) => current is AssignPoliceSuccess,
            listener: (context, state) {
              if (state is AssignPoliceSuccess) {
                context.pop();
                showTopSnackBar(
                  Overlay.of(context),
                  CustomSnackBar.success(
                    message:
                        'Police assigned successfully'.tr(),
                  ),
                );
              }
            },
            builder: (context, state) {
              if (state is AssignPoliceLoading) {
                return const AssignPoliceToEmployeesLoadingSkeleton();
              }
              return CustomAppButton(
                buttonColor: ColorsManger.primaryColor,
                textButton: 'Add'.tr(),
                onPressed: () {
                  context
                      .read<ShiftsAndPolicesCubit>()
                      .assignEmployeesToPolice(policeId: policeId);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
