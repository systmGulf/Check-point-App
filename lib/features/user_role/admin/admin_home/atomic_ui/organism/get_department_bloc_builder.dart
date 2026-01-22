import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controllers/department_cubit/department_cubit.dart';
import '../atoms/departments_item.dart';
import './department_loading_skeleton.dart';

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
          return state.error == 'Please check your internet connection'
              ? NoInternetConnectionWidget(onPressed: () {
                  context.read<DepartmentCubit>().getAllDepartments();
                })
              : Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    verticalSpace(20),
                    Text(state.error)
                  ],
                );
        } else if (state is GetDepartmentSuccess) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<DepartmentCubit>().getAllDepartments();
            },
            child: FadeInUp(
              child: ListView.builder(
                  itemCount: state.departmentList.data!.length,
                  itemBuilder: (context, index) {
                    return DepartmentItem(
                        departmentId:
                            state.departmentList.data![index].id ?? 00,
                        onTap: () async {
                          context.pushName(Routes.departmentPermission,
                              arguments: [
                                state
                                    .departmentList.data![index].departmentName,
                                state.departmentList.data![index].id
                              ]);
                        },
                        departmentName:
                            state.departmentList.data![index].departmentName ??
                                '');
                  }),
            ),
          );
        } else {
          return const DepartmentLoadingSkeleton();
        }
      },
    );
  }
}
