import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/no_data_found_animation_widget.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/enitities/user_item_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/improvements/assign_shift_to_employees_bottom_sheet.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import '../atoms/user_item_list_view.dart';
import '../molecules/users_loading_skeleton.dart';
import 'add_employee_bottom_sheet.dart';
import 'users_list_header.dart';

class AllUsersListView extends StatefulWidget {
  final ValueChanged<bool>? onSelectionModeChanged;
  final AddAccountRequestData? addAccountRequestValue;

  const AllUsersListView({
    super.key,
    this.onSelectionModeChanged,
    this.addAccountRequestValue,
  });

  @override
  State<AllUsersListView> createState() => _AllUsersListViewState();
}

class _AllUsersListViewState extends State<AllUsersListView> {
  static const _pageSize = 15;

  bool _isSelectionMode = false;
  final Set<String> _selectedEmployeeIds = {};
  String? _selectedDepartmentFilter;
  String _searchQuery = "";

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

  void _toggleSelect(String id, bool selected) {
    setState(() {
      if (selected) {
        _selectedEmployeeIds.add(id);
        if (!_isSelectionMode) {
          _isSelectionMode = true;
          widget.onSelectionModeChanged?.call(true);
        }
      } else {
        _selectedEmployeeIds.remove(id);
        if (_selectedEmployeeIds.isEmpty) {
          _isSelectionMode = false;
          widget.onSelectionModeChanged?.call(false);
        }
      }
    });
  }

  void _clearSelection() {
    setState(() {
      _selectedEmployeeIds.clear();
      _isSelectionMode = false;
      widget.onSelectionModeChanged?.call(false);
    });
  }

  void _deleteUser(EmployeeData user) {
    buildDeleteAlertDialog(
      context,
      title: 'Delete User'.tr(),
      message: 'Are you sure you want to delete this user?'.tr(),
      onYes: () {
        context.pop();
        context
            .read<EmployeeCubit>()
            .deleteUserAccount(userId: user.id ?? "")
            .then((_) => _refreshList());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      // Golden/Orange Floating Action Button to Add User
      floatingActionButton: _isSelectionMode
          ? null
          : FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                  ),
                  builder: (cnx) {
                    return BlocProvider.value(
                      value: context.read<EmployeeCubit>(),
                      child: AddEmployeeBottomSheet(
                        name: widget.addAccountRequestValue?.name,
                        mobileId: widget.addAccountRequestValue?.mobileId,
                        deviceToken: widget.addAccountRequestValue?.deviceToken,
                      ),
                    );
                  },
                );
              },
              backgroundColor: const Color(0xFFF59E0B), // Warm Gold / Orange
              elevation: 6,
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
      body: RefreshIndicator(
        color: const Color(0xFF7F1D1D),
        onRefresh: () async => _refreshList(),
        child: BlocListener<EmployeeCubit, EmployeeState>(
          listenWhen: (previous, current) =>
              current is AddEmployeeSuccess ||
              current is EditEmployeeSuccess ||
              current is DeleteUserAccountSuccess,
          listener: _handleStateChanges,
          child: Stack(
            children: [
              Column(
                children: [
                  // Top Red Banner Header
                  UsersListHeader(
                    isSelectionMode: _isSelectionMode,
                    addAccountRequestValue: widget.addAccountRequestValue,
                    onSelectionModeToggled: () {
                      setState(() {
                        _isSelectionMode = !_isSelectionMode;
                        widget.onSelectionModeChanged?.call(_isSelectionMode);
                        if (!_isSelectionMode) {
                          _selectedEmployeeIds.clear();
                        }
                      });
                    },
                    onSearchQueryChanged: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                    onDepartmentSelected: (dept) {
                      setState(() {
                        _selectedDepartmentFilter = dept;
                      });
                    },
                  ),

                  // Employee Cards List View
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14.w),
                      child: BlocBuilder<EmployeeCubit, EmployeeState>(
                        builder: (context, state) {
                          if (state is SearchEmployeeSuccess &&
                              _searchQuery.trim().isNotEmpty) {
                            final results = state.employeeList.data ?? [];
                            if (results.isEmpty) {
                              return const Center(child: NoDataFound());
                            }
                            return ListView.builder(
                              itemCount: results.length,
                              padding: EdgeInsets.only(bottom: 80.h),
                              itemBuilder: (context, index) {
                                final user = results[index];
                                return _buildUserItem(user);
                              },
                            );
                          }

                          return PagingListener(
                            controller: _pagingController,
                            builder: (context, state, fetchNextPage) {
                              return PagedListView<int, EmployeeData>(
                                state: state,
                                fetchNextPage: fetchNextPage,
                                padding: EdgeInsets.only(bottom: 80.h),
                                builderDelegate:
                                    PagedChildBuilderDelegate<EmployeeData>(
                                  itemBuilder: (context, user, index) {
                                    // Filter by Department if selected
                                    if (_selectedDepartmentFilter != null &&
                                        _selectedDepartmentFilter!.isNotEmpty) {
                                      if (user.departmentName !=
                                          _selectedDepartmentFilter) {
                                        return const SizedBox.shrink();
                                      }
                                    }
                                    return _buildUserItem(user);
                                  },
                                  firstPageProgressIndicatorBuilder: (_) =>
                                      const UsersLoadingSkeleton(count: 8),
                                  newPageProgressIndicatorBuilder: (_) =>
                                      const UsersLoadingSkeleton(count: 3),
                                  firstPageErrorIndicatorBuilder: (_) =>
                                      NoInternetConnectionWidget(
                                          onPressed: _refreshList),
                                  newPageErrorIndicatorBuilder: (_) => Padding(
                                    padding: EdgeInsets.all(16.r),
                                    child: Center(
                                      child: TextButton(
                                        onPressed: () => _refreshList(),
                                        child: Text(
                                          'Retry'.tr(),
                                          style: const TextStyle(
                                            color: Color(0xFF7F1D1D),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  noItemsFoundIndicatorBuilder: (_) =>
                                      const Center(child: NoDataFound()),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),

              // Selection Action Bottom Card
              if (_isSelectionMode)
                Positioned(
                  bottom: 20.h,
                  left: 16.w,
                  right: 16.w,
                  child: Card(
                    color: const Color(0xFF7F1D1D),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${'Selected'.tr()}: ${_selectedEmployeeIds.length}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                            ),
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
                                  foregroundColor: const Color(0xFF7F1D1D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r),
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
                                            value: context
                                                .read<ShiftsAndPolicesCubit>(),
                                          ),
                                        ],
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(bottomSheetCtx)
                                                .viewInsets
                                                .bottom,
                                          ),
                                          child:
                                              AssignShiftToEmployeesBottomSheet(
                                            employeeIds:
                                                _selectedEmployeeIds.toList(),
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

  Widget _buildUserItem(EmployeeData user) {
    return UserItemListView(
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
