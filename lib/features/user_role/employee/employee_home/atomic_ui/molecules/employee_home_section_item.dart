import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_tasks_reponse_model/employee_tasks_response_model.dart';

import '../../../../../../core/styles/styles.dart';

class EmployeeHomeSectionItem extends StatelessWidget {
  const EmployeeHomeSectionItem({
    super.key,
    required this.title,
    required this.content,
    required this.getTaskResponse,
  });
  final String title, content;
  final List<EmployeeTaskItem> getTaskResponse;

  String _priorityText(int? value) {
    switch (value) {
      case 0:
        return 'Low';
      case 1:
        return 'Medium';
      case 2:
        return 'High';
      default:
        return '--';
    }
  }

  String _stateText(int? value) {
    switch (value) {
      case 0:
        return 'Pending';
      case 1:
        return 'InProgress';
      case 2:
        return 'Completed';
      case 3:
        return 'OnHold';
      case 4:
        return 'Cancelled';
      default:
        return '--';
    }
  }

  Color _priorityTextColor(int? value) {
    switch (value) {
      case 0:
        return Colors.green.shade700;
      case 1:
        return Colors.orange.shade700;
      case 2:
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Color _priorityBgColor(int? value) {
    switch (value) {
      case 0:
        return Colors.green.shade50;
      case 1:
        return Colors.orange.shade50;
      case 2:
        return Colors.red.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  Color _stateTextColor(int? value) {
    switch (value) {
      case 0:
        return Colors.orange.shade700;
      case 1:
        return Colors.blue.shade700;
      case 2:
        return Colors.green.shade700;
      case 3:
        return Colors.purple.shade700;
      case 4:
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  Color _stateBgColor(int? value) {
    switch (value) {
      case 0:
        return Colors.orange.shade50;
      case 1:
        return Colors.blue.shade50;
      case 2:
        return Colors.green.shade50;
      case 3:
        return Colors.purple.shade50;
      case 4:
        return Colors.red.shade50;
      default:
        return Colors.grey.shade100;
    }
  }

  String _formatDeadline(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) return '--';
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) return rawDate;
    return DateFormat('MMM d, yyyy').format(parsed);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Divider(
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
                // height: 20.h,
                width: 20.w,
                decoration: BoxDecoration(
                  color: ColorsManger.primaryColor.withValues(alpha: 0.5),
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
                    content,
                    style: AppStylesManger.font15BoldRed,
                  ),
                ]),
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(getTaskResponse.length, (index) {
                    return Container(
                      // height: 110.h,
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
                          Text(
                            getTaskResponse[index].taskTitle ?? '--',
                            style: AppStylesManger.font15BoldBlack,
                          ),
                          SizedBox(
                            width: 219.w,
                            child: Text(
                              'Code: ${getTaskResponse[index].taskCode ?? '--'}',
                              style: AppStylesManger.font15BoldRed
                                  .copyWith(color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          Text(
                            'Deadline: ${_formatDeadline(getTaskResponse[index].deadLine)}',
                            style: AppStylesManger.font12RegularBlack
                                .copyWith(color: Colors.grey.shade600),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _priorityBgColor(
                                      getTaskResponse[index].priority),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Priority: ${_priorityText(getTaskResponse[index].priority)}',
                                  style: AppStylesManger.font12RegularBlack
                                      .copyWith(
                                          color: _priorityTextColor(
                                              getTaskResponse[index].priority)),
                                ),
                              ),
                              horizontalSpace(6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _stateBgColor(
                                      getTaskResponse[index].state),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'State: ${_stateText(getTaskResponse[index].state)}',
                                  style: AppStylesManger.font12RegularBlack
                                      .copyWith(
                                          color: _stateTextColor(
                                              getTaskResponse[index].state)),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 219.w,
                            child: Text(
                              getTaskResponse[index].taskDescription ?? '--',
                              style: AppStylesManger.font12RegularBlack
                                  .copyWith(color: Colors.grey.shade600),
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
