import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/utils/assets_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_floating_action_button.dart';
import '../../controllers/department_cubit/department_cubit.dart';
import '../molecules/custom_search_bar.dart';
import '../organism/add_department_bottom_sheet.dart';
import '../organism/edit_department_bloc_listener.dart';
import '../organism/get_department_bloc_builder.dart';

class DepartmentScreen extends StatelessWidget {
  const DepartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CustomFloatingActionButton(
        text: 'Add Department'.tr(),
        onTap: () {
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
      ),
      appBar: buildCustomAppBar(
        context,
        'Departments'.tr(),
      ),
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(children: [
                verticalSpace(MediaQuery.sizeOf(context).height * 0.1),
                Image.asset(Assets.DepartmentImage, height: 150),
                verticalSpace(20),
                const Expanded(
                  child: GetDepartmentBlocBuilder(),
                ),
              ])),
          Positioned(
              child: CustomSearchBar(
                  onQueryChanged: (query) {
                    BlocProvider.of<DepartmentCubit>(context)
                        .searchDepartment(query);
                  },
                  searchText: 'Search for Department...'.tr(),
                  child: BlocBuilder<DepartmentCubit, DepartmentState>(
                      builder: (context, state) {
                    if (state is SearchDepartmentLoading) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Material(
                          color: Colors.white,
                          elevation: 4.0,
                          child: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      );
                    } else if (state is SearchDepartmentSuccess) {
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
                                  leading: Icon(Icons.bar_chart,
                                      color: ColorsManger.primaryColor),
                                  trailing: Icon(Icons.chevron_right,
                                      color: ColorsManger.primaryColor),
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
