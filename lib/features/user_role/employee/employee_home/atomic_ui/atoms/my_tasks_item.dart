import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../supervisor/supervisor_home/atomic_ui/molecules/todo_flag_and_data.dart';
import '../../../../supervisor/supervisor_home/atomic_ui/molecules/todo_title_and_state.dart';

class MyTaskItem extends StatelessWidget {
  const MyTaskItem(
      {super.key,
      required this.title,
      required this.des,
      required this.status,
      required this.priority,
      required this.date, required this.onSelected});
  final String title, des, status, priority, date;
  final ValueChanged onSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
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
                  visible: false,
                  onSelected: onSelected,
                  onEdit: () {},
                  onDelete: () {},
                  toDoId: "",
                  title: title,
                  state: status,
                ),
                SizedBox(
                  width: 219.w,
                  child: Text(
                    des,
                    style: TextStyle(
                      color: Color(0x9924252C),
                      fontSize: 14.sp,
                      fontFamily: 'DM Sans',
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                verticalSpace(4),
                TodoFlagAndDateItem(
                  priority: priority,
                  date: DateFormat('yyyy-MM-dd').format(DateTime.parse(
                    date,
                  )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
