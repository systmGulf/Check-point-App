import 'package:animate_do/animate_do.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/organism/admin_notification_item_load.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:lottie/lottie.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../../../../../core/widgets/app_top_snack_bar.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../atoms/admin_notification_item.dart';

class AdminNotificationScreen extends StatefulWidget {
  const AdminNotificationScreen({super.key});

  @override
  State<AdminNotificationScreen> createState() =>
      _AdminNotificationScreenState();
}

class _AdminNotificationScreenState extends State<AdminNotificationScreen> {
  static const _pageSize = 10;

  late final PagingController<int, AddAccountRequestData> _pagingController;
  bool _hasNextPage = true;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, AddAccountRequestData>(
      getNextPageKey: (state) {
        if (!_hasNextPage) return null;
        if (state.keys?.isEmpty ?? true) return 0;
        return state.keys!.last + 1;
      },
      fetchPage: (pageKey) async {
        final cubit = context.read<EmployeeCubit>();
        final result = await cubit.fetchAccountRequestsPage(
          pageKey: pageKey,
          pageSize: _pageSize,
        );

        if (result == null) {
          throw Exception('Failed to load data');
        }

        _hasNextPage = result.length == _pageSize;
        return result;
      },
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void _refreshList() {
    context.read<EmployeeCubit>().clearAccountRequestsCache();
    _hasNextPage = true;
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildCustomAppBar(context, 'Notification'.tr()),
      body: RefreshIndicator(
        color: ColorsManger.primaryColor,
        onRefresh: () async => _refreshList(),
        child: BlocListener<EmployeeCubit, EmployeeState>(
          listener: _handleStateChanges,
          child: _buildPagedList(),
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, EmployeeState state) {
    if (state is GetAccountRequestsPaginationFailure) {
      AppTopSnackBar.showFailure(context, message: state.error);
    } else if (state is DeleteAddAccountRequestSuccess) {
      _refreshList();
    } else if (state is DeleteAddAccountRequestFailure) {
      AppTopSnackBar.showFailure(context, message: state.error);
    }
  }

  Widget _buildPagedList() {
    return PagingListener(
      controller: _pagingController,
      builder: (context, state, fetchNextPage) {
        return PagedListView<int, AddAccountRequestData>(
          state: state,
          fetchNextPage: fetchNextPage,
          builderDelegate: PagedChildBuilderDelegate<AddAccountRequestData>(
            itemBuilder: (context, item, index) => _buildNotificationItem(item),
            firstPageProgressIndicatorBuilder: (_) => _buildLoadingSkeleton(),
            newPageProgressIndicatorBuilder: (_) => _buildLoadingSkeleton(),
            firstPageErrorIndicatorBuilder: (_) => _buildErrorIndicator(),
            newPageErrorIndicatorBuilder: (_) =>
                _buildRetryButton(fetchNextPage),
            noItemsFoundIndicatorBuilder: (_) => _buildEmptyState(),
          ),
        );
      },
    );
  }

  Widget _buildNotificationItem(AddAccountRequestData item) {
    return ElasticInUp(
      child: AdminNotificationItem(
        id: item.id!,
        onTap: () {
          Navigator.pushNamed(
            context,
            Routes.allUsersScreen,
            arguments: item,
          ).then((_) => _refreshList());
        },
        name: item.name ?? "",
        mobileId: item.mobileId ?? "",
        date: item.createdDate ?? DateTime.now(),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Column(
      children: List.generate(
        3,
        (index) => const AdminNotificationItemLoad(),
      ),
    );
  }

  Widget _buildErrorIndicator() {
    final state = _pagingController.value.error;
    if (state.toString().contains('internet')) {
      return NoInternetConnectionWidget(onPressed: _refreshList);
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red),
          verticalSpace(20),
          Text(state.toString()),
          verticalSpace(10),
          TextButton(
            onPressed: _refreshList,
            child: Text(
              'Retry'.tr(),
              style: TextStyle(color: ColorsManger.primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRetryButton(VoidCallback onRetry) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: TextButton(
          onPressed: onRetry,
          child: Text(
            'Retry'.tr(),
            style: TextStyle(color: ColorsManger.primaryColor),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 150.h,
            child: Lottie.asset(
              'assets/animated_images/Alert.json',
              fit: BoxFit.contain,
            ),
          ),
          verticalSpace(20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Text(
                  "You Don't have any Notification Yet".tr(),
                  style: AppStylesManger.font20SemiBoldBlack,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          verticalSpace(10),
          Text(
            'we will send you notification soon .'.tr(),
          ),
        ],
      ),
    );
  }
}
