import 'package:employee_mangement/core/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/routing/routes.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controllers/department_cubit/department_cubit.dart';
import '../atoms/departments_item.dart';
import './department_loading_skeleton.dart';

class GetDepartmentBlocBuilder extends StatefulWidget {
  const GetDepartmentBlocBuilder({
    super.key,
  });

  @override
  State<GetDepartmentBlocBuilder> createState() =>
      _GetDepartmentBlocBuilderState();
}

class _GetDepartmentBlocBuilderState extends State<GetDepartmentBlocBuilder> {
  static const _pageSize = 10;
  late PagingController<int, DepartmentData> _pagingController;
  bool _hasNextPage = true;
  @override
  initState() {
    super.initState();
    _pagingController = PagingController<int, DepartmentData>(
      getNextPageKey: (state) {
        if (!_hasNextPage) return null;
        if (state.keys?.isEmpty ?? true) return 0;
        return state.keys!.last + 1;
      },
      fetchPage: (pageKey) async {
        final cubit = context.read<DepartmentCubit>();
        final result = await cubit.fetchDepartmentsPage(
          pageKey: pageKey,
          pageSize: _pageSize,
        );
        if (result == null) throw Exception('Failed to load data');
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

  Widget build(BuildContext context) {
    return BlocListener<DepartmentCubit, DepartmentState>(
      listener: (context, state) {
        if (state is AddDepartmentSuccess ||
            state is DeleteDepartmentSuccess ||
            state is EditDepartmentSuccess) {
          _refreshList();
        }
      },
      child: RefreshIndicator(
        onRefresh: () async => _refreshList(),
        child: PagingListener(
          controller: _pagingController,
          builder: (context, state, fetchNextPage) {
            return PagedListView<int, DepartmentData>(
              state: state,
              fetchNextPage: fetchNextPage,
              builderDelegate: PagedChildBuilderDelegate<DepartmentData>(
                itemBuilder: (context, department, index) => DepartmentItem(
                  departmentId: department.id ?? 0,
                  onTap: () {
                    context.pushName(Routes.departmentPermission, arguments: [
                      department.departmentName,
                      department.id,
                    ]);
                  },
                  departmentName: department.departmentName ?? '',
                ),
                firstPageProgressIndicatorBuilder: (_) =>
                    const DepartmentLoadingSkeleton(),
                firstPageErrorIndicatorBuilder: (_) =>
                    NoInternetConnectionWidget(onPressed: _refreshList),
                newPageProgressIndicatorBuilder: (_) =>
                    const DepartmentLoadingSkeleton(),
                newPageErrorIndicatorBuilder: (_) => Center(
                  child: TextButton(
                    onPressed: _refreshList,
                    child: Text('Retry',
                        style: AppStylesManger.font11RegularGrey.copyWith(
                          color: ColorsManger.primaryColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                        )),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
