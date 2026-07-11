import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/enums/customer_type.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:employee_mangement/core/widgets/no_interet_connextion_widget.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/controllers/customer_cubit/customer_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../core/styles/colors.dart';
import '../atoms/client_item.dart';
import '../molecules/clients_loading_skeleton.dart';
import '../molecules/custom_admin_app_bar.dart';
import 'add_client_bottom_sheet.dart';

class ClientsBodyScreen extends StatefulWidget {
  const ClientsBodyScreen({Key? key}) : super(key: key);

  @override
  State<ClientsBodyScreen> createState() => _ClientsBodyScreenState();
}

class _ClientsBodyScreenState extends State<ClientsBodyScreen> {
  static const _pageSize = 10;

  late final PagingController<int, CustomerData> _pagingController;
  late final ScrollController _scrollController;
  bool _hasNextPage = true;
  bool _isFirstPageLoaded = false;

  bool isLoading = false;
  Set<String> selectedClients = {};

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _pagingController = PagingController<int, CustomerData>(
      getNextPageKey: (state) {
        if (!_hasNextPage) return null;
        if (state.keys?.isEmpty ?? true) return 0;
        // Block auto-fetch after first page - scroll listener handles it
        if (!_isFirstPageLoaded) return null;
        return state.keys!.last + 1;
      },
      fetchPage: (pageKey) async {
        final cubit = context.read<CustomerCubit>();
        final result = await cubit.fetchCustomersPage(
          customerType: CustomerType.Customer,
          pageKey: pageKey,
          pageSize: _pageSize,
        );
        if (result == null) throw Exception('Failed to load data');
        _hasNextPage = result.hasNextPage ?? false;
        if (pageKey == 0) _isFirstPageLoaded = true;
        return result.data ?? [];
      },
    );
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_hasNextPage || !_isFirstPageLoaded) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    // Fetch next page when scrolled to 80% of list
    if (currentScroll >= maxScroll * 0.8) {
      _pagingController.fetchNextPage();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pagingController.dispose();
    super.dispose();
  }

  void _refreshList() {
    _hasNextPage = true;
    _isFirstPageLoaded = false;
    _pagingController.refresh();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CustomerCubit, CustomerState>(
      listenWhen: (previous, current) =>
          current is AddCustomerSuccess ||
          current is EditCustomerSuccess ||
          current is DeleteCustomerSuccess,
      listener: (context, state) {
        if (state is AddCustomerSuccess ||
            state is EditCustomerSuccess ||
            state is DeleteCustomerSuccess) {
          _refreshList();
        }
      },
      child: Stack(
        children: [
          RefreshIndicator(
            color: ColorsManger.primaryColor,
            onRefresh: () async => _refreshList(),
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                CustomAdminAppBar(
                  onPickExcel: () {},
                  appBarName: 'Clients',
                ),
                PagingListener(
                  controller: _pagingController,
                  builder: (context, state, fetchNextPage) {
                    return PagedSliverList<int, CustomerData>(
                      state: state,
                      fetchNextPage: fetchNextPage,
                      builderDelegate: PagedChildBuilderDelegate<CustomerData>(
                        itemBuilder: (context, client, index) => ClientItem(
                            onTap: () {},
                            onEdit: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20),
                                  ),
                                ),
                                builder: (BuildContext cnx) {
                                  return BlocProvider.value(
                                    value: context.read<CustomerCubit>(),
                                    child: AddClientBottomSheet(
                                      customerId: client.id,
                                      initialName: client.name,
                                      initialWorkedAs: client.workesAs,
                                      initialLocation: client.location,
                                      initialCoordinates: client.coordinates,
                                    ),
                                  );
                                },
                              );
                            },
                            color: selectedClients.contains(client.id)
                                ? Colors.grey.shade300
                                : Colors.white,
                            id: client.id!,
                            name: client.name!,
                            workedAs: client.workesAs!,
                            location: client.location!,
                          ),
                        firstPageProgressIndicatorBuilder: (_) =>
                            const ClientsLoadingSkeleton(count: 10),
                        newPageProgressIndicatorBuilder: (_) =>
                            const ClientsLoadingSkeleton(count: 3),
                        firstPageErrorIndicatorBuilder: (_) =>
                            NoInternetConnectionWidget(
                          onPressed: _refreshList,
                        ),
                        newPageErrorIndicatorBuilder: (_) => Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: TextButton(
                              onPressed: _refreshList,
                              child: Text(
                                'Retry'.tr(),
                                style:
                                    TextStyle(color: ColorsManger.primaryColor),
                              ),
                            ),
                          ),
                        ),
                        noItemsFoundIndicatorBuilder: (_) =>
                            const Center(child: NoDataFound()),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
