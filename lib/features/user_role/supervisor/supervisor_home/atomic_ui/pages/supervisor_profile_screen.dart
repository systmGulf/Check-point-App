import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/widgets/payslip_card.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/payslip/cubit/payslip_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../contoller/employee_profile_cubit/employee_profile_cubit.dart';
import '../widgets/profile_section_switcher.dart';
import '../widgets/supervisor_profile_personal_info_card.dart';
import '../widgets/supervisor_profile_summary_card.dart';

class SupervisorProfileScreen extends StatefulWidget {
  const SupervisorProfileScreen({super.key});

  @override
  State<SupervisorProfileScreen> createState() =>
      _SupervisorProfileScreenState();
}

class _SupervisorProfileScreenState extends State<SupervisorProfileScreen> {
  int selectedIndex = 0;

  final List<String> sections = const [
    'Summary',
    'Personal',
    'Employment',
    'Payroll',
    'Leave',
    'Performance',
    'Documents',
    'Transfer',
    'Record',
    'BENEFIT',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EmployeeProfileCubit>()..getEmployeeProfile(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<EmployeeProfileCubit>();
          return Scaffold(
            appBar: buildCustomAppBar(context, 'Employee Details'),
            body: RefreshIndicator(
              onRefresh: cubit.getEmployeeProfile,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                children: [
                  ProfileSectionSwitcher(
                    sections: sections,
                    selectedIndex: selectedIndex,
                    onSectionTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                  ),
                  verticalSpace(12),
                  if (selectedIndex == 0 || selectedIndex == 1)
                    BlocBuilder<EmployeeProfileCubit, EmployeeProfileState>(
                      builder: (context, state) {
                        if (state is GetEmployeeProfileLoading) {
                          return SizedBox(
                            height: 240,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        if (state is GetEmployeeProfileFailure) {
                          return SizedBox(
                            height: 240,
                            child: Center(
                              child: Text(
                                state.error,
                                style: AppStylesManger.font14BoldRed,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        if (state is GetEmployeeProfileSuccess) {
                          if (selectedIndex == 0) {
                            return SupervisorProfileSummaryCard(
                              profile: state.profile,
                            );
                          }
                          return SupervisorProfilePersonalInfoCard(
                            profile: state.profile,
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  if (selectedIndex == 3)
                    BlocBuilder<PayslipCubit, PayslipState>(
                      builder: (context, state) {
                        return switch (state) {
                          GetPayslipByIdLoadingState() => const Center(
                              child: CircularProgressIndicator(),
                            ),
                          GetPayslipByIdFailureState(:final msg) => Center(
                              child: Text(
                                msg,
                                style: AppStylesManger.font14BoldRed,
                              ),
                            ),
                          GetPayslipByIdSuccessState(:final paySlipModelList) =>
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: paySlipModelList.length,
                              itemBuilder: (context, index) {
                                final pasyslip = paySlipModelList[index];
                                return PayslipCard(payslip: pasyslip);
                              },
                            ),
                          _ => const SizedBox.shrink(),
                        };
                      },
                    )
                  else
                    Container(
                      height: 220,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: const Color(0xffE5E7EB)),
                      ),
                      child: Text(
                        'UI Section: ${sections[selectedIndex]}',
                        style: AppStylesManger.font16BoldBlack,
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
 