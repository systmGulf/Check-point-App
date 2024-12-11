import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../organism/time_line_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../controller/attendence/attendence_cubit.dart';

class MyPlansDetailsScreen extends StatelessWidget {
  const MyPlansDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, 'Plans Details'.tr(context: context)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: BlocBuilder<AttendanceCubit, AttendanceState>(
          buildWhen: (previous, current) =>
              current is GetPlanByIdError ||
              current is GetPlanByIdIdDone ||
              current is GetPlanByIdLoading,
          builder: (context, state) {
            if (state is GetPlanByIdIdDone) {
              return ListView.builder(
                itemCount: state.plansById.customerPlans!.length,
                itemBuilder: (context, index) {
                  return TimeLineTile(
                    date: state.plansById.planDate ?? '',
                    visitType: state.plansById.customerPlans![index].customer!
                        .customerType!,
                    visited: state.plansById.customerPlans![index].visited!,
                    isFirst: index == 0,
                    isLast: index == state.plansById.customerPlans!.length - 1,
                    name:
                        state.plansById.customerPlans![index].customer!.name ??
                            '',
                    notes: state.plansById.customerPlans![index].note ?? '',
                    workesAs: state.plansById.customerPlans![index].customer!
                            .workesAs ??
                        '',
                    location: state.plansById.customerPlans![index].customer!
                            .location ??
                        '',
                  );
                },
              );
            } else if (state is GetPlanByIdError) {
              return Text(state.error);
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
              // return ListView.builder(
              //     itemCount: 5,
              //     itemBuilder: (_, index) {
              //       return Skeletonizer(
              //           child: TimeLineTile(
              //               date: "Dta Testtsssdj",
              //               isFirst: index == 0,
              //               isLast: index == 4,
              //               name: 'Data Load',
              //               workesAs: " workesAs",
              //               location: "location",
              //               notes: "notes",
              //               visited: true,
              //               visitType: "Data Load"));
              //     });
            }
          },
        ),
      ),
    );
  }
}
