import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/enums/customer_type.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controllers/customer_cubit/customer_cubit.dart';
import '../atoms/sites_item.dart';

class SiteScreenBody extends StatelessWidget {
  const SiteScreenBody({super.key});

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
                    customerType: CustomerType.Site,
                    isLoading: true
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
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      'Sites'.tr(context: context),
                      style: AppStylesManger.font15BoldBlack,
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      childCount: state.customers.data!
                          .where(
                            (c) => c.customerType == CustomerType.Site.name,
                          )
                          .length, (
                    BuildContext context,
                    int index,
                  ) {
                    final List sites = state.customers.data!
                        .where((c) => c.customerType == CustomerType.Site.name)
                        .toList();
                    return GestureDetector(
                      onTap: () {},
                      child: SitesItem(
                        id: sites[index].id as String,
                        name: sites[index].name as String,
                        descritption: sites[index].workesAs as String,
                        location: sites[index].location as String,
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
                    'Sites'.tr(context: context),
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
                    child: SitesItem(
                      id: 'Load Data',
                      name: 'Load Data',
                      descritption: 'Load Data',
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
                      .getCustomersByType(customerType: CustomerType.Site, isLoading: true);
                })
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(child: const Icon(Icons.error, color: Colors.red)),
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
