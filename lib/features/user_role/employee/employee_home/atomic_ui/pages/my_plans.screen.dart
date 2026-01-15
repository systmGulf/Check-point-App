import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controller/attendence/attendence_cubit.dart';
import '../molecules/my_plans_widget.dart';

class MyPlansScreen extends StatelessWidget {
  const MyPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = EasyLocalization.of(context)!.locale;
    final currentLanguageCode = currentLocale.languageCode;

    final DateFormat dateFormat = DateFormat(
      tr('date_format', context: context),
      context.locale.toString(),
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Center(
                child: Transform(
                  alignment: Alignment.center,
                  transform: currentLanguageCode == 'ar'
                      ? Matrix4.rotationY(3.14)
                      : Matrix4.rotationY(0),
                  child: SvgPicture.asset('assets/images/arrow_back.svg'),
                ),
              ),
            ),
            pinned: true,
            expandedHeight: 130,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Plans'.tr(context: context),
                style: AppStylesManger.font15BoldBlack,
              ),
            ),
          ),
          BlocBuilder<AttendanceCubit, AttendanceState>(
            buildWhen: (previous, current) =>
                current is GetCustomerAreaDone ||
                current is GetCustomerAreaError ||
                current is GetCustomerAreaLoading,
            builder: (context, state) {
              if (state is GetCustomerAreaDone) {
                final data = state.customerArea.value!.data!;

                if (data.isEmpty) {
                  return const SliverToBoxAdapter(child: NoDataFound());
                }

                final Map<DateTime, List<dynamic>> groupedPlans = {};

                for (var item in data) {
                  final planDate = item.plan?.planDate;
                  if (planDate == null) continue;

                  final dateOnly = DateTime(
                    planDate.year,
                    planDate.month,
                    planDate.day,
                  );

                  groupedPlans.putIfAbsent(dateOnly, () => []);
                  groupedPlans[dateOnly]!.add(item);
                }

                final sortedDates = groupedPlans.keys.toList()
                  ..sort((a, b) => a.compareTo(b));

                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: sortedDates.length,
                    (context, index) {
                      final date = sortedDates[index];
                      final plans = groupedPlans[date]!;
                      final now = DateTime.now();

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              dateFormat.format(date),
                              style: AppStylesManger.font16BoldPrimary.copyWith(
                                color: ColorsManger.darkblue,
                              ),
                            ),
                          ),
                          ...plans.map((item) {
                            final planDate = item.plan!.planDate!;

                            return MyPlanWidget(
                              planDate: planDate,
                              now: now,
                              item: item,
                            );
                          }).toList(),
                        ],
                      );
                    },
                  ),
                );
              } else if (state is GetCustomerAreaError) {
                return SliverToBoxAdapter(
                  child: state.error == 'Please check your internet connection'
                      ? NoInternetConnectionWidget(
                          onPressed: () {
                            context.read<AttendanceCubit>().getCustomerArea();
                          },
                        )
                      : Column(
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            verticalSpace(20),
                            Text(state.error),
                          ],
                        ),
                );
              } else {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.sizeOf(context).height * 0.3,
                    ),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: ColorsManger.primaryColor,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
