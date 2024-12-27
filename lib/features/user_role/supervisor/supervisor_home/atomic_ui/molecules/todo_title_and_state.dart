import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/common/show_menu_position.dart';
import 'package:employee_mangement/core/enums/task_status.dart';
import 'package:flutter/material.dart';

class TodoTitleAndStateItem extends StatelessWidget {
  const TodoTitleAndStateItem({
    super.key,
    required this.title,
    required this.state,
    required this.toDoId,
    required this.onDelete,
    required this.onEdit,
    required this.visible,
    required this.onSelected,
  });
  final String title, state, toDoId;
  final VoidCallback onDelete, onEdit;
  final bool visible;
  final ValueChanged<String> onSelected;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF24252C),
            fontSize: 16,
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w700,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(
        width: 15,
      ),
      InkWell(
        onTap: () {
          final position = showMenuPosition(context: context);
          showMenu(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              context: context,
              position: position,
              items: [
                PopupMenuItem(
                  onTap: () {
                    onSelected(TaskStatus.InProgress.name);
                  },
                  value: TaskStatus.InProgress.name,
                  child: Text(
                    TaskStatus.InProgress.name.tr(context: context),
                    style: const TextStyle(color: const Color(0xFF5F33E1)),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    onSelected(TaskStatus.Done.name);
                  },
                  value: TaskStatus.Done.name,
                  child: Text(
                    TaskStatus.Done.name.tr(context: context),
                    style: const TextStyle(color: const Color(0xFF0087FF)),
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    onSelected(TaskStatus.Pending.name);
                  },
                  value: TaskStatus.Pending.name,
                  child: Text(
                    TaskStatus.Pending.name.tr(context: context),
                    style: const TextStyle(color: const Color(0xFFE73C3C)),
                  ),
                ),
              ]);
        },
        child: Container(
          height: 22,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: ShapeDecoration(
            color: state == TaskStatus.InProgress.name
                ? const Color(0xFFF0ECFF)
                : state == TaskStatus.Done.name
                    ? const Color(0xFFE3F2FF)
                    : Color(0XFFFFE4F2),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Text(
                  state,
                  style: TextStyle(
                    color: state == TaskStatus.Done.name
                        ? const Color(0xFF0087FF)
                        : state == TaskStatus.InProgress.name
                            ? const Color(0xFF5F33E1)
                            : const Color(0xFFE73C3C),
                    fontSize: 11,
                    fontFamily: 'DM Sans',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Visibility(
        visible: visible,
        child: Center(
          child: IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              final position = showMenuPosition(context: context);
              showMenu(
                color: Colors.white,
                context: context,
                position: position,
                clipBehavior: Clip.hardEdge,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                items: [
                  PopupMenuItem(
                    value: 'Edit',
                    onTap: onEdit,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Assign Task'.tr(context: context),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    onTap: onDelete,
                    value: 'Delete',
                    child: const Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ).then((value) {
                if (value != null) {
                  print("Selected: $value");
                }
              });
            },
            icon: const Icon(Icons.more_vert),
          ),
        ),
      ),
    ]);
  }
}
