import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controller/get_employee_history/get_employee_history_cubit.dart';
import '../molecules/history_item.dart';

class EmployeeAttendanceHistoryScreen extends StatefulWidget {
  const EmployeeAttendanceHistoryScreen({super.key});

  @override
  State<EmployeeAttendanceHistoryScreen> createState() =>
      _EmployeeAttendanceHistoryScreenState();
}

class _EmployeeAttendanceHistoryScreenState
    extends State<EmployeeAttendanceHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  int nextPageNumber = 1;
  bool isLoading = false;
  bool maxScrollExtent = false;
  List<UserAttendanceData> attendance = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.7 &&
        !isLoading &&
        !maxScrollExtent) {
      isLoading = true;
      await context
          .read<GetEmployeeHistoryCubit>()
          .getEmployeeHistory(pageNumber: nextPageNumber++);
      isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(
        context,
        'Attendance Report'.tr(context: context),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: BlocConsumer<GetEmployeeHistoryCubit, GetEmployeeHistoryState>(
          listener: (context, state) {
            if (state is GetEmployeeHistorySuccess) {
              attendance.addAll(state.attendanceHistory.data!);
           
            } else if (state is GetEmployeeHistoryPaginationFailure) {
              buildSnackBar(
                context,
                customSnackBar: CustomSnackBar.error(
                  message: state.errorMessage,
                ),
              );
            }
          },
          buildWhen: (previous, current) =>
              current is GetEmployeeHistorySuccess ||
              current is GetEmployeeHistoryFailure ||
              current is GetEmployeeHistoryLoading ||
              current is GetEmployeeHistoryPaginationLoading,
          builder: (context, state) {
            if (state is GetEmployeeHistorySuccess ||
                state is GetEmployeeHistoryPaginationLoading) {
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      controller: _scrollController,
                      itemCount: attendance.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10, top: 10),
                          child: HistoryItem(
                            // isLate: attendance[index].isLate ?? false,
                            // isEarly: attendance[index].isEarly ?? false,
                            // totalhours: attendance[index].totalHours.toString(),
                            // area: attendance[index].area ?? '',
                            // clockInTime: attendance[index].clockInTime ?? '',
                            // clockOutTime: attendance[index].clockOutTime ?? '',
                            // date: attendance[index].attendanceDate ?? '',
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  state is GetEmployeeHistoryPaginationLoading &&
                          !maxScrollExtent
                      ? Center(
                          child: CircularProgressIndicator(
                              color: ColorsManger.primaryColor),
                        )
                      : const SizedBox.shrink(),
                ],
              );
            } else if (state is GetEmployeeHistoryFailure) {
              return state.error == 'Please check your internet connection'
                  ? NoInternetConnectionWidget(onPressed: () {
                      context
                          .read<GetEmployeeHistoryCubit>()
                          .getEmployeeHistory();
                    })
                  : Column(
                      children: [
                        const Icon(Icons.error, color: Colors.red),
                        verticalSpace(20),
                        Text(state.error)
                      ],
                    );
            } else if (state is GetEmployeeHistoryLoading) {
              return Skeletonizer(
                child: ListView.builder(
                  itemBuilder: (context, index) => const Padding(
                    padding: EdgeInsets.only(bottom: 10, top: 10),
                    child: HistoryItem(
                      isLate: false,
                      isEarly: false,
                      totalhours: 'Load Data',
                      area: 'Load Data',
                      clockInTime: '22:42:21.5101114',
                      clockOutTime: '00:00:00',
                      date: 'Load Data',
                    ),
                  ),
                  itemCount: 15,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
