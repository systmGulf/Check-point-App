import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/tasks/tasks_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_tasks_reponse_model/employee_tasks_response_model.dart';

import '../../../../../../core/styles/styles.dart';
import '../../../../supervisor/supervisor_home/atomic_ui/molecules/todo_title_and_state.dart';

class EmployeeHomeSectionItem extends StatelessWidget {
  const EmployeeHomeSectionItem({
    super.key,
    required this.title,
    required this.content,
    required this.getTaskResponse,
  });
  final String title, content;
  final List<EmployeeTasks> getTaskResponse;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          thickness: 1,
        ),
        Row(
          children: [
            Text(
              title,
              style: AppStylesManger.font15BoldBlack,
            ),
            horizontalSpace(10),
            Container(
                height: 20.h,
                width: 20.w,
                decoration: BoxDecoration(
                  color: ColorsManger.primaryColor.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Center(
                    child: Text(getTaskResponse.length.toString(),
                        style: TextStyle(color: Colors.white)))),
          ],
        ),
        verticalSpace(10),
        getTaskResponse.isEmpty
            ? Center(
                child: Column(children: [
                  verticalSpace(10),
                  Text(
                    'no tasks'.tr(context: context),
                    style: AppStylesManger.font15BoldBlack,
                  ),
                  verticalSpace(2),
                  Text(
                    'you have no tasks yet'.tr(context: context),
                    style: AppStylesManger.font15BoldRed,
                  ),
                ]),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(getTaskResponse.length, (index) {
                    return Container(
                      height: 110.h,
                      width: 250.w,
                      margin: const EdgeInsetsDirectional.only(end: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TodoTitleAndStateItem(
                            visible: false,
                            onSelected: (value) {
                              context.read<EmployeeTasksCubit>().taskStatus =
                                  value;
                              BlocProvider.of<EmployeeTasksCubit>(context)
                                  .updateTaskStatus(
                                      taskId: getTaskResponse[index].id ?? 0);
                            },
                            onEdit: () {},
                            onDelete: () {},
                            toDoId: "",
                            title: getTaskResponse[index].title ?? '',
                            state: getTaskResponse[index]
                                    .status!
                                    .tr(context: context) ??
                                '',
                          ),
                          SizedBox(
                            width: 219.w,
                            child: Text(
                              getTaskResponse[index].description ?? '',
                              style: AppStylesManger.font15BoldRed
                                  .copyWith(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              )
      ],
    );
  }
}
