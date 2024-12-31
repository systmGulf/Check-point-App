import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

import '../../contoller/get_employees_data_cubit/get_employees_data_cubit.dart';
import '../../contoller/plan_cubit/plan_cubit.dart';
import '../../model/drop_down_item.dart';

class MultiSelectEmployeesDropdown extends StatefulWidget {
  const MultiSelectEmployeesDropdown({super.key});

  @override
  State<StatefulWidget> createState() => _MultiSelectEmployeesDropdownState();
}

class _MultiSelectEmployeesDropdownState
    extends State<MultiSelectEmployeesDropdown> {
  final controller = MultiSelectController<DropdownItemModel>();
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetEmployeesDataCubit, GetEmployeesDataState>(
        buildWhen: (previous, current) =>
            current is GetAllEmployeesSuccess ||
            current is GetAllEmployeesFailure ||
            current is GetAllEmployeesLoading,
        builder: (context, state) {
          if (state is GetAllEmployeesSuccess) {
            List<DropdownItem<DropdownItemModel>> dropdownItems = List.generate(
                state.allEmployeesValue.data!.length,
                (index) => DropdownItem<DropdownItemModel>(
                    label: state.allEmployeesValue.data![index].name!,
                    value: DropdownItemModel(
                        state.allEmployeesValue.data![index].deviceTokens!,
                        name: state.allEmployeesValue.data![index].name!,
                        id: state.allEmployeesValue.data![index].id!)));
            return MultiDropdown<DropdownItemModel>(
              items: dropdownItems,
              controller: controller,
              enabled: true,
              searchEnabled: true,
              chipDecoration: const ChipDecoration(
                backgroundColor: Colors.orange,
                wrap: true,
                runSpacing: 2,
                spacing: 10,
              ),
              onSelectionChange: (selectedItems) {
                context.read<PlanCubit>().dropdownItems.addAll(selectedItems);
              },
            );
          } else if (state is GetAllEmployeesFailure) {
            return Text(state.errorMsg);
          } else if (state is GetAllEmployeesLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return const SizedBox();
          }
        });
  }
}
