import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../controllers/department_cubit/department_cubit.dart';
import '../molecules/custom_search_for_item_bar.dart';
import '../organism/add_department_bottom_sheet.dart';
import '../organism/edit_department_bloc_listener.dart';
import '../organism/get_department_bloc_builder.dart';

class DepartmentScreen extends StatelessWidget {
  const DepartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            builder: (cnx2) {
              return BlocProvider.value(
                value: context.read<DepartmentCubit>(),
                child: const AddDepartmentBottomSheet(),
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: buildCustomAppBar(
        context,
        'Departments'.tr(context: context),
      ),
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                verticalSpace(MediaQuery.sizeOf(context).height * 0.1),
                Image.asset('assets/images/department.png', height: 150),
                verticalSpace(20),
                const Expanded(
                  child: GetDepartmentBlocBuilder(),
                ),
              ])),
          Positioned(
              child: CustomSearchForItemBar(
                  onQueryChanged: (query) {
                    BlocProvider.of<DepartmentCubit>(context)
                        .searchDepartment(query);
                  },
                  searchText: 'Search for Department...'.tr(context: context),
                  child: BlocBuilder<DepartmentCubit, DepartmentState>(
                      builder: (context, state) {
                    if (state is SearchDepartmentSuccess) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Material(
                          color: Colors.white,
                          elevation: 4.0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                                state.departmentList.data!.length, (index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListTile(
                                  leading: const Icon(Icons.bar_chart,
                                      color: Colors.blue),
                                  trailing: const Icon(Icons.chevron_right,
                                      color: Colors.blue),
                                  title: Text(state.departmentList.data![index]
                                          .departmentName ??
                                      ''),
                                  onTap: () {
                                    context.pushName(
                                        Routes.departmentPermission,
                                        arguments: [
                                          state.departmentList.data![index]
                                              .departmentName,
                                          state.departmentList.data![index].id
                                        ]);
                                  },
                                ),
                              );
                            }),
                          ),
                        ),
                      );
                    } else {
                      return Container();
                    }
                  }))),
          const EditDepartmentBlocListener()
        ],
      ),
    );
  }
}
