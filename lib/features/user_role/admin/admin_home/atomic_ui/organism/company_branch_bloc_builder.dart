import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/helpers/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controllers/branch_cubit/branch_cubit.dart';
import '../atoms/company_branch_item.dart';

class CompanyBranchesBlocBuilder extends StatelessWidget {
  const CompanyBranchesBlocBuilder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentLocale = EasyLocalization.of(context)!.locale;
    final currentLanguageCode = currentLocale.languageCode;
    return BlocBuilder<BranchCubit, BranchState>(
      buildWhen: ((previous, current) =>
          current is GetBranchSuccess ||
          current is GetBranchError ||
          current is GetBranchLoading),
      builder: (context, state) {
        if (state is GetBranchLoading) {
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
                expandedHeight: 150.h,
                backgroundColor: Colors.white,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 1.1,
                  title: Text('Company Branches'.tr(context: context),
                      style: AppStylesManger.font18BoldBlack),
                ),
              ),
              SliverList(
                  delegate: SliverChildBuilderDelegate(childCount: 10, (
                BuildContext context,
                int index,
              ) {
                return Skeletonizer(
                  child: CompanyBranchItem(
                    onDelete: () {},
                    name: 'data Load',
                    location: 'data Load',
                    decoration: 'data Load',
                  ),
                );
              }))
            ],
          );
        } else if (state is GetBranchSuccess) {
          return RefreshIndicator(
            onRefresh: () async {
              context.read<BranchCubit>().getBranches(isLoading: true);
            },
            child: CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  excludeHeaderSemantics: true,
                  pinned: true,
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
                            child: SvgPicture.asset(
                                'assets/images/arrow_back.svg')),
                      ),
                    ),
                  ),
                  expandedHeight: 150.h,
                  backgroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    expandedTitleScale: 1.1,
                    title: Text('Company Branches'.tr(context: context),
                        style: AppStylesManger.font18BoldBlack),
                  ),
                ),
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        childCount: state.branches.data!.length, (
                  BuildContext context,
                  int index,
                ) {
                  return FadeInUp(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(Routes.companyBranchDetails, arguments: [
                          state.branches.data![index].name,
                          state.branches.data![index].location,
                          state.branches.data![index].description,
                          state.branches.data![index].coordinates,

                          state.branches.data![index].id,
                          context,
                        ]);
                      },
                      child: CompanyBranchItem(
                        onDelete: () {
                          buildAlertDialog(context,
                              title: 'Delete Branch'.tr(context: context),
                              message:
                                  'Are you sure you want to delete this branch?'
                                      .tr(context: context), onYes: () {
                            context.pop();
                            BlocProvider.of<BranchCubit>(context).deleteBranch(
                              state.branches.data![index].id ?? 0,
                            );
                          });
                        },
                        name: state.branches.data![index].name ?? '',
                        location: state.branches.data![index].location ?? '',
                        decoration: state.branches.data![index].description ?? '',
                      ),
                    ),
                  );
                }))
              ],
            ),
          );
        } else if (state is GetBranchError) {
          return state.error == 'Please check your internet connection'
              ? NoInternetConnectionWidget(onPressed: () {
                  context.read<BranchCubit>().getBranches(isLoading: true);
                })
              : Column(
                  children: [
                    const Icon(Icons.error, color: Colors.red),
                    verticalSpace(20),
                    Text(state.error)
                  ],
                );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
