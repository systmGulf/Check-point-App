import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/features/user_role/admin/admin_home/atomic_ui/atoms/delete_user_bloc_listener.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import '../../../../../../core/dependencyـinjection/registerـfactory.dart';
import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_alart_message.dart';
import '../../../../../../core/widgets/build_snake_bar.dart';
import '../../../../../../core/widgets/no_interet_connextion_widget.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../atoms/user_item_list_view.dart';
import '../molecules/custom_search_bar.dart';
import '../pages/edit_user_screen.dart';

class AllUsersListView extends StatefulWidget {
  const AllUsersListView({
    super.key,
  });

  @override
  State<AllUsersListView> createState() => _AllUsersListViewState();
}

class _AllUsersListViewState extends State<AllUsersListView> {
  final ScrollController _scrollController = ScrollController();
  int nextPageNumber = 1;
  bool isLoading = false;
  bool maxScrollExtent = false;
  List<EmployeeData> users = [];
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() async {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent * 0.7 &&
        !isLoading &&
        !maxScrollExtent) {
      setState(() {
        isLoading = true;
      });
      await context
          .read<EmployeeCubit>()
          .getAllEmployees(pageNumber: nextPageNumber++, itemCount: 10);
      ;
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _deleteUser(int index) {
    final UserId = users[index].id;
    buildDeleteAlertDialog(context,
        title: 'Delete User'.tr(context: context),
        message: 'Are you sure you want to delete this User?'
            .tr(context: context), onYes: () {
      context.pop();
      BlocProvider.of<EmployeeCubit>(context)
          .deleteUserAccount(userId: UserId ?? "")
          .then((isSuccess) {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: RefreshIndicator(
        color: ColorsManger.primaryColor,
        onRefresh: () async {
          BlocProvider.of<EmployeeCubit>(
            context,
          ).getAllEmployees(pageNumber: 0, itemCount: 10, );
          users.clear();
          print("Refreshed =============================>${users.length}");
        },
        child: BlocConsumer<EmployeeCubit, EmployeeState>(
          listener: (context, state) {
            if (state is GetAllEmployeesSuccess) {
              setState(() {
                final newUsers = state.value.data!;
                for (var newUser in newUsers) {
                  if (!users.any((user) => user.id == newUser.id)) {
                    users.add(newUser);
                  }
                }
                maxScrollExtent = !state.value.hasNextPage!;
              });
            } else if (state is GetAllEmployeesPaginationFailure) {
              buildSnackBar(
                context,
                customSnackBar: CustomSnackBar.error(
                  message: state.error,
                ),
              );
            } else if (state is GetAllEmployeesLoading) {
              users.clear();
            }
          },
          buildWhen: (previous, current) =>
              current is GetAllEmployeesSuccess ||
              current is GetAllEmployeesFailure ||
              current is GetAllEmployeesLoading ||
              current is GetAllEmployeesPaginationLoading,
          builder: (context, state) {
            if (state is GetAllEmployeesSuccess ||
                state is GetAllEmployeesPaginationLoading) {
              return Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView(
                      controller: _scrollController,
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: 59.h,
                        ),
                        DeleteUserBlocListener(),
                        Row(
                          children: [
                            Text('Users List'.tr(context: context),
                                style: AppStylesManger.font15BoldBlack),
                            const Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: ColorsManger.primaryColor),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  state is GetAllEmployeesSuccess
                                      ? state.value.totalCount.toString()
                                      : '0',
                                  style: AppStylesManger.font14regularWhite,
                                ),
                              ),
                            )
                          ],
                        ),
                        verticalSpace(10),
                        ListView.builder(
                          itemCount: users.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (_, index) => Padding(
                            padding: const EdgeInsets.only(bottom: 7),
                            child: UserItemListView(
                              imageUrl: users[index].imageUrl ?? '',
                              onDelete: () => _deleteUser(index),
                              branchId: users[index].branchId ?? 0,
                              branch: users[index].branchName ?? "",
                              departmentId: users[index].departmentId ?? 0,
                              role: users[index].role ?? "",
                              mobileId: users[index].mobileId ?? "",
                              userName: users[index].userName ?? "",
                              department: users[index].departmentName ?? "",
                              userId: users[index].id ?? "",
                              name: users[index].name ?? "",
                              position: users[index].position ?? "",
                            ),
                          ),
                        ),
                        if (state is GetAllEmployeesPaginationLoading &&
                            !maxScrollExtent)
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: ColorsManger.primaryColor),
                            ),
                          ),
                      ],
                    ),
                  ),
                  CustomSearchBar(
                    onQueryChanged: (query) {
                      BlocProvider.of<EmployeeCubit>(context)
                          .searchEmployee(name: query);
                    },
                    searchText: 'Please enter user name'.tr(context: context),
                    child: BlocBuilder<EmployeeCubit, EmployeeState>(
                        builder: (context, state) {
                      if (state is SearchEmployeeSuccess) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Material(
                            color: Colors.white,
                            elevation: 4.0,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                  state.employeeList.data!.length, (index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListTile(
                                    leading: Icon(Icons.person,
                                        color: ColorsManger.primaryColor),
                                    trailing: Icon(Icons.chevron_right,
                                        color: ColorsManger.primaryColor),
                                    title: Text(
                                        state.employeeList.data![index].name ??
                                            ''),
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) {
                                            return BlocProvider(
                                              create: (context) =>
                                                  getIt<EmployeeCubit>(),
                                              child: EditUser(
                                                branchId:
                                                    state.employeeList.data![index].branchId ?? 0,
                                                branch:
                                                    state.employeeList.data![index].branchName ??
                                                        "",
                                                departmentId:
                                                    state.employeeList.data![index].departmentId ??
                                                        0,
                                                mobileId:
                                                    state.employeeList.data![index].mobileId ?? "",
                                                role: state.employeeList.data![index].role ?? "",
                                                id: state.employeeList.data![index].id ?? "",
                                                name: state.employeeList.data![index].name ?? "",
                                                userName:
                                                    state.employeeList.data![index].userName ?? "",
                                                position:
                                                    state.employeeList.data![index].position ?? "",
                                                department: state.employeeList.data![index]
                                                        .departmentName ??
                                                    "",
                                              ),
                                            );
                                          },
                                        ),
                                      ).then((value) {
                                        context
                                            .read<EmployeeCubit>()
                                            .getAllEmployees(
                                                pageNumber: 0, itemCount: 10);
                                      });
                                    },
                                  ),
                                );
                              }),
                            ),
                          ),
                        );
                      } else {
                        return Container();
                      }
                    }),
                  ),
                ],
              );
            } else if (state is GetAllEmployeesLoading) {
              return Skeletonizer(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Text('Users List'.tr(context: context),
                            style: AppStylesManger.font15BoldBlack),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: ColorsManger.primaryColor),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            child: Text(
                              '0',
                              style: AppStylesManger.font14regularWhite,
                            ),
                          ),
                        )
                      ],
                    ),
                    ListView.builder(
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (_, index) => Padding(
                        padding: const EdgeInsets.only(bottom: 7),
                        child: UserItemListView(
                          imageUrl: "",
                          onDelete: () {},
                          branchId: 0,
                          branch: "Data Load",
                          departmentId: 0,
                          role: "Data Load",
                          mobileId: "Data Load",
                          userName: "Data Load",
                          department: "Data Load",
                          userId: "Data Load",
                          name: "Data Load",
                          position: "Data Load",
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is GetAllEmployeesFailure) {
              return state.error == 'Please check your internet connection'
                  ? NoInternetConnectionWidget(onPressed: () {
                      context
                          .read<EmployeeCubit>()
                          .getAllEmployees(pageNumber: 0, itemCount: 10);
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
        ),
      ),
    );
  }
}
