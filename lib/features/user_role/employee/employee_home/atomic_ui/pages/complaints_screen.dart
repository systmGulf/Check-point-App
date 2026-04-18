import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:employee_mangement/core/widgets/custom_new_floating_action_button.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/atomic_ui/pages/add_complaint_screen.dart';
import 'package:employee_mangement/features/user_role/employee/employee_home/controller/complaints/complaints_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  Future<void> _openAddComplaintScreen() async {
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: context.read<ComplaintsCubit>(),
          child: const AddComplaintScreen(),
        ),
      ),
    );

    if (created == true && mounted) {
      context.read<ComplaintsCubit>().getComplaints();
    }
  }

  String _statusText(BuildContext context, int? status) {
    switch (status) {
      case 0:
        return 'Pending'.tr(context: context);
      case 1:
        return 'In Progress'.tr(context: context);
      case 2:
        return 'Completed'.tr(context: context);
      case 3:
        return 'Cancelled'.tr(context: context);
      default:
        return '--';
    }
  }

  Color _statusColor(int? status) {
    switch (status) {
      case 0:
        return Colors.orange;
      case 1:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 3:
        return Colors.red;
      default:
        return ColorsManger.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, 'Complaints'.tr(context: context)),
      backgroundColor: ColorsManger.scaffoldBackgroundColor,
      floatingActionButton: CustomNewFloatingActionButton(
        onPressed: _openAddComplaintScreen,
      ),
      body: SafeArea(
        child: BlocBuilder<ComplaintsCubit, ComplaintsState>(
          buildWhen: (previous, current) =>
              current is GetComplaintsLoadingState ||
              current is GetComplaintsSuccessState ||
              current is GetComplaintsFailureState,
          builder: (context, state) => switch (state) {
            GetComplaintsLoadingState() =>
              const Center(child: CircularProgressIndicator()),
            GetComplaintsFailureState(:final error) => Center(
                child: Text(error),
              ),
            GetComplaintsSuccessState(:final complaints) => complaints
                        .value?.isEmpty ??
                    true
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Expanded(child: NoDataFound()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'No complaints yet'.tr(context: context),
                          style: AppStylesManger.font18RegulerBlack,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalSpace(8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Add your first complaint to get started'
                              .tr(context: context),
                          style: AppStylesManger.font14regulargray,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      verticalSpace(40),
                    ],
                  )
                : RefreshIndicator(
                    onRefresh: () =>
                        context.read<ComplaintsCubit>().getComplaints(),
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      itemCount: complaints.value?.length ?? 0,
                      separatorBuilder: (_, __) => verticalSpace(12),
                      itemBuilder: (context, index) {
                        final complaint = complaints.value?[index];
                        final statusColor = _statusColor(complaint?.status);

                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      complaint?.subject ??
                                          'No description'.tr(context: context),
                                      style: AppStylesManger.font18RegulerBlack
                                          .copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: statusColor.withValues(
                                        alpha: 0.12,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      _statusText(context, complaint?.status),
                                      style: AppStylesManger.font12RegularGrey
                                          .copyWith(color: statusColor),
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpace(10),
                              Text(
                                complaint?.description ??
                                    'No description'.tr(context: context),
                                style:
                                    AppStylesManger.font14regulargray.copyWith(
                                  color: Colors.black87,
                                ),
                              ),
                              verticalSpace(12),
                              if ((complaint?.employeeName ?? '')
                                  .trim()
                                  .isNotEmpty)
                                Text(
                                  '${'Employee'.tr(context: context)}: ${complaint?.employeeName}',
                                  style: AppStylesManger.font12RegularGrey,
                                ),
                              if ((complaint?.resolutionNote ?? '')
                                  .trim()
                                  .isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    '${'Resolution Note'.tr(context: context)}: ${complaint?.resolutionNote}',
                                    style: AppStylesManger.font12RegularGrey,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
            _ => const SizedBox.shrink(),
          },
        ),
      ),
    );
  }
}
