import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:slide_switcher/slide_switcher.dart';

import '../../../../../../core/animations/animations.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controller/attendence/attendence_cubit.dart';
import '../../controller/get_employee_history/get_employee_history_cubit.dart';
import '../../controller/tasks/tasks_cubit.dart';
import '../../../../../../core/contoller/roles_login_cubit/login_cubit.dart';
import '../molecules/employee_home_section_item.dart';
import '../molecules/office_checking_in.dart';
import 'employee_attendace_bloc_builder.dart';
import 'get_employee_data_in_employee_home_screen_bloc_builder.dart';

class EmployeeHomeScreenBody extends StatefulWidget {
  const EmployeeHomeScreenBody({super.key});

  @override
  State<EmployeeHomeScreenBody> createState() => _EmployeeHomeScreenBodyState();
}

class _EmployeeHomeScreenBodyState extends State<EmployeeHomeScreenBody> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<LoginCubit>().getEmployeeById();
        context.read<GetEmployeeHistoryCubit>().getEmployeeHistory(pageNumber: 0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> checkingText = [
      'Office'.tr(),
      'Customer'.tr(
        context: context,
      ),
      'Site'.tr(
        context: context,
      )
    ];

    return Stack(
      children: [
        AnimatedByWidgetType(
          widgetType: WidgetAnimationType.image,
          child: Image.asset(
            'assets/images/banner-home.png',
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: RefreshIndicator(
            color: ColorsManger.primaryColor,
            onRefresh: () async {
              BlocProvider.of<GetEmployeeHistoryCubit>(context)
                  .getEmployeeHistory();
              BlocProvider.of<EmployeeTasksCubit>(context).getMyTasks();
              BlocProvider.of<LoginCubit>(context).getEmployeeById();
            },
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                verticalSpace(15),
                const AnimatedByWidgetType(
                  widgetType: WidgetAnimationType.header,
                  delayDuration: Duration(milliseconds: 100),
                  child: GetEmployeeDataInEmployeeHomeScreenBlocBuilder(),
                ),
                verticalSpace(15),
                AnimatedByWidgetType(
                  widgetType: WidgetAnimationType.container,
                  delayDuration: const Duration(milliseconds: 200),
                  child: Center(
                    child: Directionality(
                      textDirection: ui.TextDirection.ltr,
                      child: SlideSwitcher(
                        initialIndex: selectedIndex,
                        onSelect: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        containerColor: ColorsManger.primaryColor,
                        slidersBorder:
                            Border.all(color: ColorsManger.primaryColor),
                        containerHeight: 40.h,
                        containerWight: MediaQuery.sizeOf(context).width / 1.2,
                        children: List.generate(3, (index) {
                          return Text(
                            checkingText[index],
                            style: AppStylesManger.font18BoldBlack.copyWith(
                              color: selectedIndex == index
                                  ? ColorsManger.primaryColor
                                  : Colors.white,
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                verticalSpace(20),
                AnimatedByWidgetType(
                  widgetType: WidgetAnimationType.container,
                  delayDuration: const Duration(milliseconds: 300),
                  child: BlocListener<AttendanceCubit, AttendanceState>(
                    listener: (context, attendanceState) {
                      if (attendanceState is AttendanceIneDone ||
                          attendanceState is AttendanceOutedDone) {
                        context.read<LoginCubit>().getEmployeeById();
                        context
                            .read<GetEmployeeHistoryCubit>()
                            .getEmployeeHistory(pageNumber: 0);
                      }
                    },
                    child: BlocBuilder<GetEmployeeHistoryCubit, GetEmployeeHistoryState>(
                      builder: (context, historyState) {
                        String? historyCheckIn;
                        String? historyCheckOut;

                        if (historyState is GetEmployeeHistorySuccess &&
                            historyState.attendanceHistory.data != null &&
                            historyState.attendanceHistory.data!.isNotEmpty) {
                          final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
                          final todayRecords = historyState.attendanceHistory.data!.where((record) {
                            final date = record.attendanceDate;
                            if (date == null || date.isEmpty) return false;
                            return date.startsWith(todayStr);
                          }).toList();

                          if (todayRecords.isNotEmpty) {
                            final firstRecord = todayRecords.first;
                            if (firstRecord.clockInTime != null &&
                                firstRecord.clockInTime!.isNotEmpty &&
                                firstRecord.clockInTime != 'null') {
                              historyCheckIn = firstRecord.clockInTime;
                            }
                            if (firstRecord.clockOutTime != null &&
                                firstRecord.clockOutTime!.isNotEmpty &&
                                firstRecord.clockOutTime != 'null') {
                              historyCheckOut = firstRecord.clockOutTime;
                            }
                          }
                        }

                        return BlocBuilder<LoginCubit, LoginState>(
                          buildWhen: (previous, current) =>
                              current is GetEmployeeSuccess ||
                              current is LoginSuccess ||
                              current is GetEmployeeLoading ||
                              current is GetEmployeeFailure,
                          builder: (context, loginState) {
                            String? checkIn = historyCheckIn;
                            String? checkOut = historyCheckOut;

                            if (checkIn == null || checkIn.isEmpty) {
                              if (loginState is GetEmployeeSuccess) {
                                checkIn = loginState.employeeLoginModel.clockInTime;
                                checkOut = loginState.employeeLoginModel.clockOutTime;
                              } else if (loginState is LoginSuccess && loginState.employeeLoginModel != null) {
                                try {
                                  checkIn = loginState.employeeLoginModel.clockInTime;
                                  checkOut = loginState.employeeLoginModel.clockOutTime;
                                } catch (_) {}
                              }
                            }

                            return CheckInOrCheckOutWidget(
                              attendType: selectedIndex == 0
                                  ? 'Office'
                                  : selectedIndex == 1
                                      ? 'Customer'
                                      : 'Site',
                              checkInTime: checkIn,
                              checkOutTime: checkOut,
                              onTypeChanged: (type) {
                                setState(() {
                                  selectedIndex = type == 'Office'
                                      ? 0
                                      : type == 'Customer'
                                          ? 1
                                          : 2;
                                });
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                verticalSpace(30),
                AnimatedByWidgetType(
                  widgetType: WidgetAnimationType.card,
                  delayDuration: const Duration(milliseconds: 400),
                  child: BlocBuilder<EmployeeTasksCubit, EmployeeTasksState>(
                    buildWhen: (previous, current) =>
                        current is GetMyTasksError ||
                        current is GetMyTasksSuccess ||
                        current is GetMyTasksLoading,
                    builder: (context, state) {
                      if (state is GetMyTasksError) {
                        return Text(state.error);
                      }
                      if (state is GetMyTasksSuccess) {
                        return EmployeeHomeSectionItem(
                          getTaskResponse: state.getTaskResponse,
                          title: 'New tasks today'.tr(
                            context: context,
                          ),
                          content:
                              'No Alert available for today. Please check back again tomorrow.'
                                  .tr(
                            context: context,
                          ),
                        );
                      }
                      return Skeletonizer(
                          child: EmployeeHomeSectionItem(
                        getTaskResponse: [],
                        title: 'Data Loading'.tr(
                          context: context,
                        ),
                        content:
                            'No Alert available for today. Please check back again tomorrow.'
                                .tr(
                          context: context,
                        ),
                      ));
                    },
                  ),
                ),
                verticalSpace(30),
                AnimatedByWidgetType(
                  widgetType: WidgetAnimationType.text,
                  delayDuration: const Duration(milliseconds: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'History'.tr(
                          context: context,
                        ),
                        style: AppStylesManger.font18RegulerBlack,
                      ),
                      GestureDetector(
                          onTap: () {
                            context.pushName(
                                Routes.employeeAttendanceHistoryScreen);
                          },
                          child: const Icon(Icons.arrow_forward_ios_outlined))
                    ],
                  ),
                ),
                verticalSpace(10),
                const AnimatedByWidgetType(
                  widgetType: WidgetAnimationType.listItem,
                  delayDuration: Duration(milliseconds: 600),
                  child: EmployeeAttendanceBlocBuilder(),
                ),
                verticalSpace(10),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
