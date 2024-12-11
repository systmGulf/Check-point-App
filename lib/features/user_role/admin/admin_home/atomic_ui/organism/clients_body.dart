import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hr_management_system_package/admin/data/repo/customer_repo/customer_repo.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/enums/customer_type.dart';
import '../../../../../../core/styles/styles.dart';
import '../../controllers/customer_cubit/customer_cubit.dart';
import '../atoms/client_item.dart';
import '../pages/client_profile_screen.dart';

class ClientsBodyScreen extends StatelessWidget {
  const ClientsBodyScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = EasyLocalization.of(context)!.locale;
    final currentLanguageCode = currentLocale.languageCode;
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        if (state is GetAllCustomersSuccess) {
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
                          child:
                              SvgPicture.asset('assets/images/arrow_back.svg')),
                    ),
                  ),
                ),
                excludeHeaderSemantics: true,
                pinned: true,
                expandedHeight: 130.0,
                backgroundColor: Colors.white,
                elevation: 0,
                scrolledUnderElevation: 0.5,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Clients'.tr(context: context),
                      style: AppStylesManger.font15BoldBlack),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: state.customers.data!
                          .where((c) =>
                              c.customerType == CustomerType.Customer.name)
                          .length, (
                BuildContext context,
                int index,
              ) {
                List clients = state.customers.data!
                    .where((c) => c.customerType == CustomerType.Customer.name)
                    .toList();
                return GestureDetector(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return BlocProvider(
                          create: (context) => CustomerCubit(
                            getIt<CustomerRepo>(),
                          ),
                          child: ClientProfileScreen(
                            mapLoaction: LatLng(
                                clients[index].coordinates![0].latitude!,
                                clients[index].coordinates![0].longitude!),
                            id: clients[index].id ?? '',
                            name: clients[index].name ?? '',
                            workedAs: clients[index].workesAs ?? '',
                            location: clients[index].location ?? '',
                          ),
                        );
                      },
                    )).then((value) => BlocProvider.of<CustomerCubit>(context)
                            .getCustomersByType(
                          customerType: CustomerType.Customer,
                        ));
                  },
                  child: ClientItem(
                    id: clients[index].id ?? '',
                    name: clients[index].name ?? '',
                    workedAs: clients[index].workesAs ?? '',
                    location: clients[index].location ?? '',
                  ),
                );
              }))
            ],
          );
        } else {
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
                          child:
                              SvgPicture.asset('assets/images/arrow_back.svg')),
                    ),
                  ),
                ),
                excludeHeaderSemantics: true,
                pinned: true,
                expandedHeight: 130.0,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('Clients'.tr(context: context),
                      style: AppStylesManger.font15BoldBlack),
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
              }))
            ],
          );
        }
      },
    );
  }
}
