import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/employee_infrastructure/data/models/employee_tasks_reponse_model/employee_tasks_response_model.dart';

class TasksScreen extends StatelessWidget {
  final List<EmployeeTasks> tasks;
  final String? userImageUrl;

  const TasksScreen({
    Key? key,
    required this.tasks,
    this.userImageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final counts = _getStatusCounts(tasks);

    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFC),
      appBar: buildCustomAppBar(context, 'Tasks'.tr()),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      _buildStatsCards(counts),

                      const SizedBox(height: 24),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Today's Tasks".tr(),
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            '${tasks.length} ${"tasks".tr()}',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      if (tasks.isEmpty)
                        _buildEmptyState()
                      else
                        ...tasks.asMap().entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: TaskCard(task: entry.value),
                          );
                        }).toList(),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCards(Map<String, int> counts) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            count: counts['all']!,
            label: 'All Tasks'.tr(),
            gradient: null,
            textColor: const Color(0xFF111827),
            backgroundColor: Colors.white,
            borderColor: Colors.grey.shade100,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            count: counts['pending']!,
            label: 'Pending'.tr(),
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF7ED), Color(0xFFFED7AA)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            textColor: const Color(0xFFC2410C),
            backgroundColor: null,
            borderColor: const Color(0xFFFED7AA),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            count: counts['inprogress']!,
            label: 'Active'.tr(),
            gradient: const LinearGradient(
              colors: [Color(0xFFEFF6FF), Color(0xFFBFDBFE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            textColor: const Color(0xFF1D4ED8),
            backgroundColor: null,
            borderColor: const Color(0xFFBFDBFE),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(
            count: counts['completed']!,
            label: 'Done'.tr(),
            gradient: const LinearGradient(
              colors: [Color(0xFFF0FDF4), Color(0xFFBBF7D0)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            textColor: const Color(0xFF15803D),
            backgroundColor: null,
            borderColor: const Color(0xFFBBF7D0),
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Icon(
              Icons.add,
              size: 32,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No tasks yet'.tr(),
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your first task to get started'.tr(),
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Map<String, int> _getStatusCounts(List<EmployeeTasks> tasks) {
    return {
      'all': tasks.length,
      'pending': tasks.where((t) =>
          t.status?.toLowerCase() == 'pending' ||
          t.status?.toLowerCase() == 'new').length,
      'inprogress': tasks.where((t) =>
          t.status?.toLowerCase() == 'inprogress' ||
          t.status?.toLowerCase() == 'in progress').length,
      'completed': tasks.where((t) =>
          t.status?.toLowerCase() == 'completed' ||
          t.status?.toLowerCase() == 'done').length,
    };
  }
}

class _StatCard extends StatelessWidget {
  final int count;
  final String label;
  final Gradient? gradient;
  final Color textColor;
  final Color? backgroundColor;
  final Color borderColor;

  const _StatCard({
    required this.count,
    required this.label,
    required this.gradient,
    required this.textColor,
    required this.backgroundColor,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count',
            style: TextStyle(
              color: textColor,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor.withOpacity(0.8),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final EmployeeTasks task;

  const TaskCard({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final priority = _getPriorityConfig(task.priorityStatus ?? 'medium');
    final status = _getStatusConfig(task.status ?? 'pending');
    final employeeImage = task.employees?.isNotEmpty == true
        ? task.employees!.first.imageUrl
        : null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey.shade100,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFDCEAFF), Color(0xFFC7D2FE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFBFDBFE),
                width: 1,
              ),
            ),
            child: employeeImage != null && employeeImage.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      employeeImage,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.grid_view_rounded,
                          color: Colors.blue.shade600,
                          size: 28,
                        );
                      },
                    ),
                  )
                : Icon(
                    Icons.grid_view_rounded,
                    color: Colors.blue.shade600,
                    size: 28,
                  ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title ?? 'Untitled Task'.tr(),
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            task.description ?? 'No description'.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(
                        Icons.more_vert,
                        size: 16,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: priority['bg'],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.flag,
                            size: 12,
                            color: priority['color'],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            priority['label'].toString().tr(),
                            style: TextStyle(
                              color: priority['color'],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    horizontalSpace(8),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: status['bg'],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: status['border'],
                          width: 1,
                        ),
                      ),
                      child: Text(
                        status['label'].toString().tr(),
                        style: TextStyle(
                          color: status['color'],
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const Spacer(),

                    if (task.dueDate != null)
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 14,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDate(task.dueDate!),
                            style: TextStyle(
                              color: Colors.grey.shade400,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getPriorityConfig(String priority) {
    final p = priority.toLowerCase();
    if (p.contains('low')) {
      return {'label': 'Low', 'color': Colors.grey.shade600, 'bg': Colors.grey.shade100};
    } else if (p.contains('high')) {
      return {'label': 'High', 'color': Colors.red.shade600, 'bg': Colors.red.shade100};
    }
    return {'label': 'Medium', 'color': Colors.blue.shade600, 'bg': Colors.blue.shade100};
  }

  Map<String, dynamic> _getStatusConfig(String status) {
    final s = status.toLowerCase();
    if (s.contains('pending') || s.contains('new')) {
      return {
        'label': 'Pending',
        'color': Colors.orange.shade600,
        'bg': Colors.orange.shade100,
        'border': Colors.orange.shade200,
      };
    } else if (s.contains('inprogress') || s.contains('active')) {
      return {
        'label': 'In Progress',
        'color': Colors.blue.shade600,
        'bg': Colors.blue.shade100,
        'border': Colors.blue.shade200,
      };
    } else if (s.contains('completed') || s.contains('done')) {
      return {
        'label': 'Completed',
        'color': Colors.green.shade600,
        'bg': Colors.green.shade100,
        'border': Colors.green.shade200,
      };
    }
    return {
      'label': status,
      'color': Colors.grey.shade600,
      'bg': Colors.grey.shade100,
      'border': Colors.grey.shade200,
    };
  }

  String _formatDate(String dateString) {
    try {
      final d = DateTime.parse(dateString);
      return '${d.month}/${d.day}/${d.year}';
    } catch (e) {
      return dateString;
    }
  }
}
