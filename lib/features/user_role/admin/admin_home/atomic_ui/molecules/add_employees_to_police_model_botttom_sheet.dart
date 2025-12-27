import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multi_dropdown.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/custom_app_button.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';

class AddEmployeesToPoliceyModelBottomSheet extends StatefulWidget {
  const AddEmployeesToPoliceyModelBottomSheet(
      {super.key, required this.policeId});
  final int policeId;

  @override
  State<AddEmployeesToPoliceyModelBottomSheet> createState() =>
      _AddEmployeesToPoliceyModelBottomSheetState();
}

class _AddEmployeesToPoliceyModelBottomSheetState
    extends State<AddEmployeesToPoliceyModelBottomSheet> {
  MultiSelectController<String>? controller;
  @override
  Widget build(BuildContext context) {
    return Padding(
    padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: IntrinsicHeight(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              BlocBuilder<EmployeeCubit, EmployeeState>(
                buildWhen: (previous, current) =>
                    current is GetAllEmployeesLoading ||
                    current is GetAllEmployeesSuccess ||
                    current is GetAllEmployeesFailure,
                builder: (context, state) {
                  if (state is GetAllEmployeesLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is GetAllEmployeesSuccess) {
                    return MultiDropdown<String>(
                      items: List.generate(
                          state.value.data!.length,
                          (index) => DropdownItem<String>(
                              label: state.value.data![index].name.toString(),
                              value: state.value.data![index].id.toString())),
                      controller: controller,
                      enabled: true,
                      fieldDecoration: FieldDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'select employees'.tr(context: context),
                      ),
                      searchEnabled: true,
                      searchDecoration: SearchFieldDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        hintText: 'Search'.tr(context: context),
                      ),
                      chipDecoration: ChipDecoration(
                        backgroundColor: ColorsManger.primaryColor,
                        wrap: true,
                        runSpacing: 2,
                        labelStyle: const TextStyle(
                          color: Colors.white,
                        ),
                        deleteIcon: const Icon(
                          Icons.delete,
                          color: Colors.white,
                          size: 16,
                        ),
                        spacing: 10,
                      ),
                      onSelectionChange: (selectedItems) {
                        context.read<ShiftsAndPolicesCubit>().employeesIds =
                            List<String>.generate(selectedItems.length,
                                (index) => selectedItems[index]);
                      },
                    );
                  } else {
                    return const Center(child: Text('Error'));
                  }
                },
              ),
              verticalSpace(20),
              BlocConsumer<ShiftsAndPolicesCubit, ShiftsAndPolicesState>(
                listener: (context, state) {
                  if (state is AssignPoliceSuccess) {
                
                    context.pop();
                    showTopSnackBar(
                      Overlay.of(context),
                      CustomSnackBar.success(
                        message:
                            'Police assigned successfully'.tr(context: context),
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  if (state is AssignPoliceLoading) {
                    return Skeletonizer(
                      child: CustomAppButton(
                        buttonColor: ColorsManger.primaryColor,
                        textButton: 'Add'.tr(context: context),
                        onPressed: () {},
                      ),
                    );
                  }
                  return CustomAppButton(
                    buttonColor: ColorsManger.primaryColor,
                    textButton: 'Add'.tr(context: context),
                    onPressed: () {
                      context
                          .read<ShiftsAndPolicesCubit>()
                          .assignEmployeesToPolice(policeId: widget.policeId);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
