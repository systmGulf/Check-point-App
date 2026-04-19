import 'package:animate_do/animate_do.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/pages/surveys_screen.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/atomic_ui/widgets/payslip_card.dart';
import 'package:employee_mangement/features/user_role/supervisor/supervisor_home/contoller/payslip/cubit/payslip_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/custom_new_floating_action_button.dart';
import '../../contoller/employee_profile_cubit/employee_profile_benefit_request_cubit.dart';
import '../../contoller/employee_profile_cubit/employee_profile_cubit.dart';
import '../../contoller/employee_profile_cubit/employee_profile_skill_cubit.dart';
import '../widgets/profile_section_switcher.dart';
import '../widgets/supervisor_profile_add_skill_bottom_sheet.dart';
import '../widgets/supervisor_profile_benefits_card.dart';
import '../widgets/supervisor_profile_edit_bottom_sheet.dart';
import '../widgets/supervisor_profile_loading_skeleton.dart';
import '../widgets/supervisor_profile_personal_info_card.dart';
import '../widgets/supervisor_profile_request_benefit_bottom_sheet.dart';
import '../widgets/supervisor_profile_skills_card.dart';
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
    'Skills',
    "Benefits",
    'Payroll',
    "Surveys",
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<EmployeeProfileCubit>()..getEmployeeProfile(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<EmployeeProfileCubit>();
          return Scaffold(
              appBar: buildCustomAppBar(context, 'Profile'),
              floatingActionButton: (selectedIndex == 2 || selectedIndex == 3)
                  ? BlocBuilder<EmployeeProfileCubit, EmployeeProfileState>(
                      builder: (context, state) {
                        if (state is! GetEmployeeProfileSuccess) {
                          return const SizedBox.shrink();
                        }
                        final employeeId =
                            (state.profile.id ?? '').trim().isNotEmpty
                                ? (state.profile.id ?? '').trim()
                                : ApiConstant.employeeId.trim();
                        if (employeeId.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final firstName =
                            (state.profile.personalInfo?.firstName ?? '')
                                .trim();
                        final lastName =
                            (state.profile.personalInfo?.lastName ?? '').trim();
                        final profileName = [firstName, lastName]
                            .where((e) => e.isNotEmpty)
                            .join(' ')
                            .trim();
                        final employeeName = profileName.isNotEmpty
                            ? profileName
                            : ApiConstant.username.trim();

                        return CustomNewFloatingActionButton(
                          onPressed: () {
                            if (selectedIndex == 2) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (_) {
                                  return BlocProvider(
                                    create: (context) =>
                                        EmployeeProfileSkillCubit(
                                      getIt(),
                                    )..loadAllSkills(),
                                    child: SupervisorProfileAddSkillBottomSheet(
                                      employeeId: employeeId,
                                      onSkillAdded: cubit.getEmployeeProfile,
                                    ),
                                  );
                                },
                              );
                              return;
                            }

                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20),
                                ),
                              ),
                              builder: (_) {
                                return BlocProvider(
                                  create: (context) =>
                                      EmployeeProfileBenefitRequestCubit(
                                    getIt(),
                                  )..loadAllBenefits(),
                                  child:
                                      SupervisorProfileRequestBenefitBottomSheet(
                                    employeeId: employeeId,
                                    employeeName: employeeName,
                                    onBenefitRequested:
                                        cubit.getEmployeeProfile,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      },
                    )
                  : null,
              body: RefreshIndicator(
                  onRefresh: cubit.getEmployeeProfile,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(12),
                    children: [
                      FadeInDown(
                        duration: const Duration(milliseconds: 320),
                        child: ProfileSectionSwitcher(
                          sections: sections,
                          selectedIndex: selectedIndex,
                          onSectionTap: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                        ),
                      ),
                      verticalSpace(12),
                      if (selectedIndex == 0 ||
                          selectedIndex == 1 ||
                          selectedIndex == 2 ||
                          selectedIndex == 3)
                        BlocBuilder<EmployeeProfileCubit, EmployeeProfileState>(
                          builder: (context, state) {
                            if (state is GetEmployeeProfileLoading) {
                              return SupervisorProfileLoadingSkeleton(
                                selectedIndex: selectedIndex,
                              );
                            }
                            if (state is GetEmployeeProfileFailure) {
                              return SizedBox(
                                key: const ValueKey('profile_failure'),
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
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 320),
                                  switchInCurve: Curves.easeOutCubic,
                                  switchOutCurve: Curves.easeInCubic,
                                  child: FadeInUp(
                                    key: const ValueKey('summary_card'),
                                    duration: const Duration(milliseconds: 320),
                                    child: SupervisorProfileSummaryCard(
                                      profile: state.profile,
                                    ),
                                  ),
                                );
                              }
                              if (selectedIndex == 1) {
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 320),
                                  switchInCurve: Curves.easeOutCubic,
                                  switchOutCurve: Curves.easeInCubic,
                                  child: FadeInUp(
                                    key: const ValueKey('personal_card'),
                                    duration: const Duration(milliseconds: 320),
                                    child: SupervisorProfilePersonalInfoCard(
                                      profile: state.profile,
                                      onEdit: () {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          backgroundColor: Colors.white,
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(20),
                                            ),
                                          ),
                                          builder: (_) {
                                            return BlocProvider.value(
                                              value: context
                                                  .read<EmployeeProfileCubit>(),
                                              child:
                                                  SupervisorProfileEditBottomSheet(
                                                profile: state.profile,
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                );
                              }
                              if (selectedIndex == 3) {
                                return AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 320),
                                  switchInCurve: Curves.easeOutCubic,
                                  switchOutCurve: Curves.easeInCubic,
                                  child: FadeInUp(
                                    key: const ValueKey('benefits_card'),
                                    duration: const Duration(milliseconds: 320),
                                    child: SupervisorProfileBenefitsCard(
                                      benefits: state.benefits,
                                    ),
                                  ),
                                );
                              }

                              return AnimatedSwitcher(
                                duration: const Duration(milliseconds: 320),
                                switchInCurve: Curves.easeOutCubic,
                                switchOutCurve: Curves.easeInCubic,
                                child: FadeInUp(
                                  key: const ValueKey('skills_card'),
                                  duration: const Duration(milliseconds: 320),
                                  child: SupervisorProfileSkillsCard(
                                    skills: state.userSkills,
                                  ),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      if (selectedIndex == 4)
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
                              GetPayslipByIdSuccessState(
                                :final paySlipModelList
                              ) =>
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
                        ),
                      if (selectedIndex == 5) SurveysScreen(),

                      // else
                      //   AnimatedSwitcher(
                      //     duration: const Duration(milliseconds: 300),
                      //     child: FadeInUp(
                      //       key: ValueKey('placeholder_$selectedIndex'),
                      //       duration: const Duration(milliseconds: 280),
                      //       child: Container(
                      //         height: 220,
                      //         alignment: Alignment.center,
                      //         decoration: BoxDecoration(
                      //           color: Colors.white,
                      //           borderRadius: BorderRadius.circular(14),
                      //           border: Border.all(color: const Color(0xffE5E7EB)),
                      //         ),
                      //         child: Text(
                      //           'UI Section: ${sections[selectedIndex]}',
                      //           style: AppStylesManger.font16BoldBlack,
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                    ],
                  )));
        },
      ),
    );
  }
}
