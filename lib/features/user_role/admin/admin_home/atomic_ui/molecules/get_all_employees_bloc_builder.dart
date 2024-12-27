import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../../../supervisor/supervisor_home/contoller/tasks_cubit/tasks_cubit.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../atoms/delete_user_bloc_listener.dart';
import '../atoms/user_irem_grid_view.dart';
import '../atoms/user_item_list_view.dart';

class GetAllEmployeesBlocBuilder extends StatefulWidget {
  const GetAllEmployeesBlocBuilder({
    super.key,
  });

  @override
  State<GetAllEmployeesBlocBuilder> createState() =>
      _GetAllEmployeesBlocBuilderState();
}

class _GetAllEmployeesBlocBuilderState extends State<GetAllEmployeesBlocBuilder>
    with TickerProviderStateMixin {
  late AnimationController progress;
  @override
  void initState() {
    super.initState();
    progress = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
  }

  bool isPressed = true;

  changeIcon() {
    setState(() {
      isPressed = !isPressed;
      if (isPressed) {
        progress.forward();
      } else {
        progress.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EmployeeCubit, EmployeeState>(
        buildWhen: (previous, current) =>
            current is GetAllEmployeesSuccess ||
            current is GetAllEmployeesFailure ||
            current is GetAllEmployeesLoading,
        builder: (context, state) {
          if (state is GetAllEmployeesSuccess) {
            return Column(
              children: [
                Row(
                  children: [
                    Text('Users List'.tr(context: context),
                        style: AppStylesManger.font15BoldBlack),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        changeIcon();
                        setState(() {});
                      },
                      child: AnimatedIcon(
                        icon: AnimatedIcons.list_view,
                        color: ColorsManger.primaryColor,
                        size: 30,
                        progress: progress,
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                        style: ButtonStyle(
                            foregroundColor: WidgetStateProperty.all(
                                ColorsManger.primaryColor)),
                        onPressed: () {
                          context.pushName(
                            Routes.allUsersScreen,
                          );
                        },
                        child: Text('see all'.tr(context: context),
                            style: AppStylesManger.font13regulerBlue)),
                  ],
                ),
                const SizedBox(height: 5),
                isPressed == false
                    ? GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: 0.75,
                        ),
                        shrinkWrap: true,
                        itemCount: state.value.data!.length > 5
                            ? 5
                            : state.value.data!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: UserItemGridView(
                              branchId: state.value.data![index].branchId ?? 0,
                              branch: state.value.data![index].branchName ?? "",
                              departmentId:
                                  state.value.data![index].departmentId ?? 0,
                              mobileId: state.value.data![index].mobileId ?? "",
                              role: state.value.data![index].role ?? "",
                              userName: state.value.data![index].userName ?? "",
                              department:
                                  state.value.data![index].departmentName ?? "",
                              userId: state.value.data![index].id ?? "",
                              name: state.value.data![index].name ?? "",
                              position: state.value.data![index].position ?? "",
                            ),
                          );
                        })
                    : ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.value.data!.length > 5
                            ? 5
                            : state.value.data!.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 5),
                            child: UserItemListView(
                              onDelete: () {
                                buildAlertDialog(context,
                                    title: 'Delete Task'.tr(context: context),
                                    message:
                                        'Are you sure you want to delete this Task?'
                                            .tr(context: context), onYes: () {
                                  context.pop();

                                  context.read<TasksCubit>().deleteTask(
                                      id: int.parse(state.value.data![index].id
                                          .toString()));
                                });
                              },
                              branchId: state.value.data![index].branchId ?? 0,
                              branch: state.value.data![index].branchName ?? "",
                              departmentId:
                                  state.value.data![index].departmentId ?? 0,
                              mobileId: state.value.data![index].mobileId ?? "",
                              role: state.value.data![index].role ?? "",
                              userName: state.value.data![index].userName ?? "",
                              department:
                                  state.value.data![index].departmentName ?? "",
                              userId: state.value.data![index].id ?? "",
                              name: state.value.data![index].name ?? "",
                              position: state.value.data![index].position ?? "",
                            ),
                          );
                        }),
                const DeleteUserBlocListener()
              ],
            );
          } else if (state is GetAllEmployeesLoading) {
            return Skeletonizer(
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Users List'.tr(context: context),
                          style: AppStylesManger.font15BoldBlack),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          changeIcon();
                          setState(() {});
                        },
                        child: AnimatedIcon(
                          icon: AnimatedIcons.list_view,
                          color: ColorsManger.primaryColor,
                          size: 30,
                          progress: progress,
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton(
                          style: ButtonStyle(
                              foregroundColor: WidgetStateProperty.all(
                                  ColorsManger.primaryColor)),
                          onPressed: () {},
                          child: Text('see all'.tr(context: context),
                              style: AppStylesManger.font13regulerBlue)),
                    ],
                  ),
                  ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (_, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: UserItemListView(
                        onDelete: () {},
                        branchId: 0,
                        branch: "Data Load",
                        departmentId: 0,
                        role: "Data Load",
                        mobileId: "Data Load",
                        userName: "Data Load",
                        department: "Data Load",
                        userId: "Data Load",
                        name: "Data Load",
                        position: "Data Load",
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is GetAllEmployeesFailure) {
            return Text(state.error);
          } else {
            return Container();
          }
        });
  }
}
