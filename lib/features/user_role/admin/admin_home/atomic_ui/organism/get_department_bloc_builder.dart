import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../controllers/department_cubit/department_cubit.dart';
import '../atoms/departments_item.dart';

class GetDepartmentBlocBuilder extends StatelessWidget {
  const GetDepartmentBlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DepartmentCubit, DepartmentState>(
      buildWhen: (_, currentState) =>
          currentState is GetDepartmentSuccess ||
          currentState is GetDepartmentLoading ||
          currentState is GetDepartmentError,
      builder: (context, state) {
        if (state is GetDepartmentError) {
          return SizedBox(
            child: Text(state.error),
          );
        } else if (state is GetDepartmentSuccess) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<DepartmentCubit>().getAllDepartments();
            },
            child: ListView.builder(
                itemCount: state.departmentList.data!.length,
                itemBuilder: (context, index) {
                  return DepartmentItem(
                      departmentId: state.departmentList.data![index].id ?? 00,
                      onTap: () async {
                        context
                            .pushName(Routes.departmentPermission, arguments: [
                          state.departmentList.data![index].departmentName,
                          state.departmentList.data![index].id
                        ]);
                      },
                      departmentName:
                          state.departmentList.data![index].departmentName ??
                              '');
                }),
          );
        } else {
          return ListView.builder(
              itemCount: 10,
              itemBuilder: (context, index) {
                return Skeletonizer(
                  child: DepartmentItem(
                      departmentId: 00,
                      onTap: () {},
                      departmentName: 'Loading...'),
                );
              });
        }
      },
    );
  }
}
