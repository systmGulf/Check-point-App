import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controller/get_employee_history/get_employee_history_cubit.dart';
import '../molecules/history_item.dart';

class EmployeeAttendanceBlocBuilder extends StatelessWidget {
  const EmployeeAttendanceBlocBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetEmployeeHistoryCubit, GetEmployeeHistoryState>(
        builder: (context, state) {
      if (state is GetEmployeeHistorySuccess) {
        return state.attendanceHistory.data!.isNotEmpty
            ? ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: state.attendanceHistory.data!.length > 3
                    ? 3
                    : state.attendanceHistory.data!.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: HistoryItem(
                      totalhours: state
                          .attendanceHistory.data![index].totalHours
                          .toString(),
                      area: state.attendanceHistory.data![index].area ?? '',
                      clockInTime:
                          state.attendanceHistory.data![index].clockInTime ??
                              '',
                      clockOutTime:
                          state.attendanceHistory.data![index].clockOutTime ??
                              '',
                      date:
                          state.attendanceHistory.data![index].attendanceDate ??
                              '',
                    ),
                  );
                })
            : Center(
                child: Text(
                    'No attendance history Yet'.tr(
                      context: context,
                    ),
                    style: AppStylesManger.font15BoldRed),
              );
      } else if (state is GetEmployeeHistoryFailure) {
        return state.error == 'Please check your internet connection'
            ? NoInternetConnectionWidget(onPressed: () {
                context
                    .read<GetEmployeeHistoryCubit>()
                    .getEmployeeHistory(pageNumber: 0);
              })
            : Column(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  verticalSpace(20),
                  Text(state.error)
                ],
              );
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    });
  }
}
