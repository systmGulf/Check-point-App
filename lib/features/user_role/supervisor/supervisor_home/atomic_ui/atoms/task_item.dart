import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/supervisor/data/models/task_model/get_task_response.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../molecules/todo_flag_and_data.dart';
import '../molecules/todo_title_and_state.dart';

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.title,
    required this.description,
    required this.priority,
    required this.date,
    required this.state,
    required this.id,
    required this.tasks,
    required this.onDelete,
    required this.onEdit,
    required this.employeeName,
  });
  final String title, description, priority, date, state;
  final String id;
  final List<GetTasData> tasks;
  final VoidCallback onDelete, onEdit;

  final List<GetEmployeesForTheTask> employeeName;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 64.h,
                  width: 64.w,
                  child: Image.asset('assets/images/pngwing.com.png'),
                ),
                horizontalSpace(14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TodoTitleAndStateItem(
                        visible: true,
                        onEdit: widget.onEdit,
                        onDelete: widget.onDelete,
                        toDoId: widget.id,
                        title: widget.title,
                        state: widget.state,
                      ),
                      SizedBox(
                        width: 219.w,
                        child: Text(
                          widget.description,
                          style: TextStyle(
                            color: Color(0x9924252C),
                            fontSize: 14.sp,
                            fontFamily: 'DM Sans',
                            fontWeight: FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      verticalSpace(4),
                      TodoFlagAndDateItem(
                        priority: widget.priority,
                        date: widget.date,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            verticalSpace(8),
            Wrap(
                alignment: WrapAlignment.start,
                children: List.generate(widget.employeeName.length, (index) {
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(widget.employeeName[index].name ?? ''),
                  );
                })),
            Divider(
              thickness: 1,
            )
          ],
        ),
      ),
    );
  }
}
