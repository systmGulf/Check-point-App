import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../atoms/admin_notification_item.dart';

class AdminNotificationScreen extends StatelessWidget {
  const AdminNotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, 'Notification'.tr(context: context)),
      body: BlocBuilder<EmployeeCubit, EmployeeState>(
        buildWhen: (previous, current) =>
            current is GetAddAccountRequestsSuccess ||
            current is GetAddAccountRequestsFailure ||
            current is GetAddAccountRequestsLoading,
        builder: (context, state) {
          if (state is GetAddAccountRequestsSuccess) {
            return state.value.data!.isNotEmpty
                ? ElasticInUp(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: state.value.data!.length,
                        itemBuilder: (context, index) {
                          return AdminNotificationItem(
                            id: state.value.data![index].id!,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Routes.allUsersScreen,
                                arguments: state.value.data![index],
                              ).then((_) =>
                                  BlocProvider.of<EmployeeCubit>(context)
                                      .getAddAccountRequests());
                            },
                            name: state.value.data![index].name ?? "",
                            mobileId: state.value.data![index].mobileId ?? "",
                            date: state.value.data![index].createdDate ??
                                DateTime.now(),
                          );
                        }),
                  )
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: 150.h,
                            child: Lottie.asset(
                                'assets/animated_images/Alert.json',
                                fit: BoxFit.contain)),
                        verticalSpace(20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "You Don't have any Notification Yet"
                                  .tr(context: context),
                              style: AppStylesManger.font20semiBoldBlack,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        verticalSpace(10),
                        Text('we will send you notification soon .'
                            .tr(context: context))
                      ],
                    ),
                  );
          } else if (state is GetAddAccountRequestsFailure) {
            return state.error ==
                    'Please check your internet connection'.tr(context: context)
                ? NoInternetConnectionWidget(onPressed: () {
                    context.read<EmployeeCubit>().getAddAccountRequests();
                  })
                : Column(
                    children: [
                      const Icon(Icons.error, color: Colors.red),
                      verticalSpace(20),
                      Text(state.error)
                    ],
                  );
          } else if (state is GetAddAccountRequestsLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: ColorsManger.primaryColor,
              strokeWidth: 2,
              backgroundColor: ColorsManger.lighorage,
            ));
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
