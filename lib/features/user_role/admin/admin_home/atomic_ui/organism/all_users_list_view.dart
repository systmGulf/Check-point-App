import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/enitities/user_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import '../../../../../../core/improvements/assign_shift_to_employees_bottom_sheet.dart';
import '../atoms/user_item_list_view.dart';
import '../molecules/custom_search_bar.dart';
import '../molecules/users_loading_skeleton.dart';
import 'user_search_results_list.dart';
import 'users_list_header.dart';

class AllUsersListView extends StatefulWidget {
  const AllUsersListView({super.key});

  @override
  State<AllUsersListView> createState() => _AllUsersListViewState();
}

class _AllUsersListViewState extends State<AllUsersListView> {
  static const _pageSize = 10;

  bool _isSelectionMode = false;
  final Set<String> _selectedEmployeeIds = {};

  void _toggleSelect(String id, bool selected) {
    setState(() {
      if (selected) {
        _selectedEmployeeIds.add(id);
        _isSelectionMode = true;
      } else {
        _selectedEmployeeIds.remove(id);
        if (_selectedEmployeeIds.isEmpty) {
          _isSelectionMode = false;
        }
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedEmployeeIds.clear();
      _isSelectionMode = false;
    });
  }

  late final PagingController<int, EmployeeData> _pagingController;
  bool _hasNextPage = true;

  @override
  void initState() {
    super.initState();
    _pagingController = PagingController<int, EmployeeData>(
      getNextPageKey: (state) {
        if (!_hasNextPage) return null;
        if (state.keys?.isEmpty ?? true) return 0;
        return state.keys!.last + 1;
      },
      fetchPage: (pageKey) async {
        final cubit = context.read<EmployeeCubit>();
        final result = await cubit.fetchEmployeesPage(
          pageKey: pageKey,
          pageSize: _pageSize,
        );

        if (result == null) {
          throw Exception('Failed to load data');
        }

        _hasNextPage = result.hasNextPage ?? false;
        return result.data ?? [];
      },
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  void _refreshList() {
    _hasNextPage = true;
    _pagingController.refresh();
  }

  void _deleteUser(EmployeeData user) {
    buildDeleteAlertDialog(
      context,
      title: 'Delete User'.tr(),
      message:
          'Are you sure you want to delete this User?'.tr(),
      onYes: () {
        context.pop();
        BlocProvider.of<EmployeeCubit>(context)
            .deleteUserAccount(userId: user.id ?? "")
            .then((_) => _refreshList());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: RefreshIndicator(
        color: ColorsManger.primaryColor,
        onRefresh: () async => _refreshList(),
        child: BlocListener<EmployeeCubit, EmployeeState>(
          listenWhen: (previous, current) =>
              current is AddEmployeeSuccess ||
              current is EditEmployeeSuccess ||
              current is DeleteUserAccountSuccess,
          listener: _handleStateChanges,
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(child: UsersListHeader()),
                    PagingListener(
                      controller: _pagingController,
                      builder: (context, state, fetchNextPage) {
                        return PagedSliverList<int, EmployeeData>(
                          state: state,
                          fetchNextPage: fetchNextPage,
                          builderDelegate:
                              PagedChildBuilderDelegate<EmployeeData>(
                            itemBuilder: (context, user, index) => Padding(
                              padding: const EdgeInsets.only(bottom: 7),
                              child: UserItemListView(
                                isSelectionMode: _isSelectionMode,
                                isSelected: _selectedEmployeeIds.contains(user.id),
                                onSelectedChanged: (selected) =>
                                    _toggleSelect(user.id ?? "", selected ?? false),
                                userItemEntity: UserItemEntity(
                                  imageUrl: user.imageUrl ?? '',
                                  onDelete: () => _deleteUser(user),
                                  branchId: user.branchId ?? 0,
                                  branch: user.branchName ?? "",
                                  departmentId: user.departmentId ?? 0,
                                  role: user.role ?? "",
                                  mobileId: user.mobileId ?? "",
                                  userName: user.userName ?? "",
                                  department: user.departmentName ?? "",
                                  userId: user.id ?? "",
                                  name: user.name ?? "",
                                  position: user.position ?? "",
                                  shiftEndTime: user.clockOutTime ?? "",
                                  shiftName: user.shiftName ?? "",
                                  shiftStartTime: user.clockInTime ?? "",
                                ),
                              ),
                            ),
                            firstPageProgressIndicatorBuilder: (_) =>
                                const UsersLoadingSkeleton(count: 10),
                            newPageProgressIndicatorBuilder: (_) =>
                                const UsersLoadingSkeleton(count: 3),
                            firstPageErrorIndicatorBuilder: (_) =>
                                NoInternetConnectionWidget(
                                    onPressed: _refreshList),
                            newPageErrorIndicatorBuilder: (_) => Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: TextButton(
                                  onPressed: () => _refreshList(),
                                  child: Text(
                                    'Retry'.tr(),
                                    style: TextStyle(
                                        color: ColorsManger.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                            noItemsFoundIndicatorBuilder: (_) =>
                                const Center(child: NoDataFound()),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              CustomSearchBar(
                onQueryChanged: (query) {
                  BlocProvider.of<EmployeeCubit>(context)
                      .searchEmployee(name: query);
                },
                searchText: 'Please enter user name'.tr(),
                child: UserSearchResultsList(onNavigateBack: _refreshList),
              ),
              if (_isSelectionMode)
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Card(
                    color: ColorsManger.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${'Selected'.tr()}: ${_selectedEmployeeIds.length}",
                            style: AppStylesManger.font14RegularWhite.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: _clearSelection,
                                child: Text(
                                  'Clear'.tr(),
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: ColorsManger.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (bottomSheetCtx) {
                                      return MultiBlocProvider(
                                        providers: [
                                          BlocProvider.value(
                                            value: context.read<ShiftsAndPolicesCubit>(),
                                          ),
                                        ],
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(bottomSheetCtx).viewInsets.bottom,
                                          ),
                                          child: AssignShiftToEmployeesBottomSheet(
                                            employeeIds: _selectedEmployeeIds.toList(),
                                            onSuccess: () {
                                              _clearSelection();
                                              _refreshList();
                                            },
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: Text('Assign Shift'.tr()),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  void _handleStateChanges(BuildContext context, EmployeeState state) {
    if (state is AddEmployeeSuccess ||
        state is EditEmployeeSuccess ||
        state is DeleteUserAccountSuccess) {
      _refreshList();
    }
  }
}


