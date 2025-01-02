// ignore_for_file: avoid_dynamic_calls

import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/dependency%D9%80injection/register%D9%80factory.dart';
import 'package:employee_mangement/core/enums/customer_type.dart';
import 'package:employee_mangement/core/styles/styles.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/atoms/client_item.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/pages/client_profile_screen.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/customer_cubit/customer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/admin/data/repo/customer_repo/customer_repo.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';

class ClientsBodyScreen extends StatelessWidget {
  const ClientsBodyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = EasyLocalization.of(context)!.locale;
    final currentLanguageCode = currentLocale.languageCode;
    return BlocBuilder<CustomerCubit, CustomerState>(
      buildWhen: ((previous, current) =>
          current is GetAllCustomersSuccess ||
          current is GetAllCustomersError ||
          current is GetAllCustomersLoading),
      builder: (context, state) {
        if (state is GetAllCustomersSuccess) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<CustomerCubit>().getCustomersByType(
                    customerType: CustomerType.Customer,
                  );
            },
            child: CustomScrollView(
              slivers: <Widget>[
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
                          child:
                              SvgPicture.asset('assets/images/arrow_back.svg'),
                        ),
                      ),
                    ),
                  ),
                  excludeHeaderSemantics: true,
                  pinned: true,
                  expandedHeight: 130,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  scrolledUnderElevation: 0.5,
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Clients'.tr(context: context),
                      style: AppStylesManger.font15BoldBlack,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: state.customers.data!
                          .where(
                            (c) => c.customerType == CustomerType.Customer.name,
                          )
                          .length, (
                    BuildContext context,
                    int index,
                  ) {
                    final List clients = state.customers.data!
                        .where(
                          (c) => c.customerType == CustomerType.Customer.name,
                        )
                        .toList();
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          // ignore: inference_failure_on_instance_creation
                          MaterialPageRoute(
                            builder: (context) {
                              return BlocProvider(
                                create: (context) => CustomerCubit(
                                  getIt<CustomerRepo>(),
                                ),
                                child: ClientProfileScreen(
                                  mapLoaction: LatLng(
                                    clients[index].coordinates![0].latitude!
                                        as double,
                                    clients[index].coordinates![0].longitude!
                                        as double,
                                  ),
                                  id: clients[index].id as String,
                                  name: clients[index].name as String,
                                  workedAs: clients[index].workesAs as String,
                                  location: clients[index].location as String,
                                ),
                              );
                            },
                          ),
                        ).then(
                          (value) {
                            return BlocProvider.of<CustomerCubit>(context)
                                .getCustomersByType(
                              customerType: CustomerType.Customer,
                            );
                          },
                        );
                      },
                      child: ClientItem(
                        id: clients[index].id as String,
                        name: clients[index].name as String,
                        workedAs: clients[index].workesAs as String,
                        location: clients[index].location as String,
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        } else if (state is GetAllCustomersLoading) {
          return CustomScrollView(
            slivers: <Widget>[
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
                        child: SvgPicture.asset('assets/images/arrow_back.svg'),
                      ),
                    ),
                  ),
                ),
                excludeHeaderSemantics: true,
                pinned: true,
                expandedHeight: 130,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Clients'.tr(context: context),
                    style: AppStylesManger.font15BoldBlack,
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(childCount: 10, (
                  BuildContext context,
                  int index,
                ) {
                  return const Skeletonizer(
                    child: ClientItem(
                      id: '',
                      name: 'Load Data',
                      workedAs: 'Load Data',
                      location: 'Load Data',
                    ),
                  );
                }),
              ),
            ],
          );
        } else if (state is GetAllCustomersError) {
          return state.error == 'Please check your internet connection'
              ? NoInternetConnectionWidget(onPressed: () {
                  context
                      .read<CustomerCubit>()
                      .getCustomersByType(customerType: CustomerType.Customer);
                })
              : Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    verticalSpace(20),
                    Text(state.error)
                  ],
                );
        } else {
          return Container();
        }
      },
    );
  }
}
