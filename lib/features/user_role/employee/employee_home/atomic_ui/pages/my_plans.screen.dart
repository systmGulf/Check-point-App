import 'package:easy_localization/easy_localization.dart';
import '../../../../../../core/widgets/no_data_found_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/styles/styles.dart';
import '../../controller/attendence/attendence_cubit.dart';
import 'my_plans_details_screen.dart';

class MyPlansScreen extends StatelessWidget {
  const MyPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = EasyLocalization.of(context)!.locale;
    final currentLanguageCode = currentLocale.languageCode;
    DateFormat dateFormat = DateFormat(
        tr('date_format', context: context), context.locale.toString());
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        SliverAppBar(
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: SizedBox(
              height: 24,
              width: 24,
              child: Center(
                child: Transform(
                    alignment: Alignment.center,
                    transform: currentLanguageCode == 'ar'
                        ? Matrix4.rotationY(3.14)
                        : Matrix4.rotationY(0),
                    child: SvgPicture.asset('assets/images/arrow_back.svg')),
              ),
            ),
          ),
          excludeHeaderSemantics: true,
          pinned: true,
          expandedHeight: 130.0,
          backgroundColor: Colors.white,
          flexibleSpace: FlexibleSpaceBar(
            title: Text('Plans'.tr(context: context),
                style: AppStylesManger.font15BoldBlack),
          ),
        ),
        BlocBuilder<AttendanceCubit, AttendanceState>(
            bloc: BlocProvider.of<AttendanceCubit>(context),
            buildWhen: (previous, current) =>
                current is GetCustomerAreaDone ||
                current is GetCustomerAreaError ||
                current is GetCustomerAreaLoading,
            builder: (context, state) {
              if (state is GetCustomerAreaDone) {
                return state.customerArea.data!.isNotEmpty
                    ? SliverList(
                        delegate: SliverChildBuilderDelegate(
                            childCount: state.customerArea.data!.length, (
                          BuildContext context,
                          int index,
                        ) {
                          return state.customerArea.data![index].planDate !=
                                  null
                              ? GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return BlocProvider.value(
                                        value: context.read<AttendanceCubit>()
                                          ..getPlanById(
                                              id: state.customerArea
                                                  .data![index].id!),
                                        child: const MyPlansDetailsScreen(),
                                      );
                                    }));
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey),
                                    ),
                                    child: Row(
                                      children: [
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "You Have Plan In"
                                                    .tr(context: context),
                                                style: AppStylesManger
                                                    .font15BoldBlack),
                                            Text(
                                                dateFormat.format(
                                                    DateTime.parse(state
                                                        .customerArea
                                                        .data![index]
                                                        .planDate!)),
                                                style: AppStylesManger
                                                    .font14RegularBlack),
                                            SizedBox(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.7,
                                              child: Text(
                                                '${"Notes".tr(context: context)}: ${state.customerArea.data![index].note ?? 'No Notes'.tr(context: context)}',
                                                style: AppStylesManger
                                                    .font14RegularBlack,
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                                dateFormat.format(DateTime.parse(state.customerArea.data![index].planDate!)) ==
                                                        DateFormat('dd MMMM yyyy').format(
                                                            DateTime.now())
                                                    ? 'The plan is Today'
                                                        .tr(context: context)
                                                    : int.parse(DateFormat('dd').format(DateTime.parse(state.customerArea.data![index].planDate!))) <
                                                            int.parse(DateFormat('dd').format(
                                                                DateTime.now()))
                                                        ? "The plan is Over".tr(
                                                            context: context)
                                                        : ' ${int.parse(DateFormat('dd').format(DateTime.parse(state.customerArea.data![index].planDate!))) - int.parse(DateFormat('dd').format(DateTime.now()))} ${"Days Left".tr(context: context)}',
                                                style: dateFormat.format(
                                                            DateTime.parse(state
                                                                .customerArea
                                                                .data![index]
                                                                .planDate!)) ==
                                                        DateFormat('dd MMMM yyyy').format(DateTime.now())
                                                    ? AppStylesManger.font14RedularGreen
                                                    : AppStylesManger.font14RedularRed),
                                          ],
                                        ),
                                        const Spacer(),
                                        const Icon(Icons.location_on_outlined)
                                      ],
                                    ),
                                  ))
                              : SliverToBoxAdapter(
                                  child: Center(
                                      child: Text('No Plans Found'
                                          .tr(context: context))));
                        }),
                      )
                    : SliverToBoxAdapter(
                        child: Center(
                            child: Lottie.asset(
                                'assets/animated_images/no_data_found.json')));
              } else if (state is GetCustomerAreaError) {
                return SliverToBoxAdapter(child: NoDataFound());
              } else {
                return SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()));
              }
            })
      ]),
    );
  }
}
