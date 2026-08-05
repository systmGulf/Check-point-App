import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/app_top_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/dependency%D9%80injection/register%D9%80factory.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/widgets/custom_loading_indicator.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../atoms/delete_user_bloc_listener.dart';
import 'add_employee_bottom_sheet.dart';

class UsersListHeader extends StatefulWidget {
  const UsersListHeader({
    super.key,
    this.isSelectionMode = false,
    this.onSelectionModeToggled,
    this.onSearchQueryChanged,
    this.onDepartmentSelected,
    this.addAccountRequestValue,
  });

  final bool isSelectionMode;
  final VoidCallback? onSelectionModeToggled;
  final ValueChanged<String>? onSearchQueryChanged;
  final ValueChanged<String?>? onDepartmentSelected;
  final AddAccountRequestData? addAccountRequestValue;

  @override
  State<UsersListHeader> createState() => _UsersListHeaderState();
}

class _UsersListHeaderState extends State<UsersListHeader> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedDepartment = "All";
  List<String> _departments = ["All"];
  bool _isLoadingDepts = false;

  @override
  void initState() {
    super.initState();
    _fetchDepartments();
  }

  Future<void> _fetchDepartments() async {
    setState(() => _isLoadingDepts = true);
    try {
      final deptRepo = getIt<DepartmentRepo>();
      final result = await deptRepo.getAllDepartments(pageKey: 0, pageSize: 50);
      result.fold(
        (l) => null,
        (r) {
          if (mounted && r.data != null) {
            final names = r.data!
                .map((d) => d.departmentName ?? "")
                .where((name) => name.isNotEmpty)
                .toList();
            setState(() {
              _departments = ["All", ...names];
            });
          }
        },
      );
    } catch (e) {
      debugPrint("Error fetching department filter chips: $e");
    } finally {
      if (mounted) setState(() => _isLoadingDepts = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EmployeeCubit, EmployeeState>(
      listenWhen: (previous, current) =>
          current is ExportEmployeesLoading ||
          current is ExportEmployeesSuccess ||
          current is ExportEmployeesFailure,
      listener: (context, state) {
        if (state is ExportEmployeesLoading) {
          customLoadingIndicator(context);
        } else if (state is ExportEmployeesSuccess) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.success(
              message: 'Export success'.tr(),
            ),
          );
        } else if (state is ExportEmployeesFailure) {
          context.pop();
          showTopSnackBar(
            Overlay.of(context),
            CustomSnackBar.error(
              message: state.error.tr(),
            ),
          );
        }
      },
      child: Column(
        children: [
          const DeleteUserBlocListener(),
          // Dark Red Header Banner
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF7F1D1D), // Dark Crimson Red
                  Color(0xFF991B1B), // Deep Red
                  Color(0xFFB91C1C), // Primary Red
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(28.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7F1D1D).withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 18.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar (Back, Title + Subtitle, Add / Actions)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 38.r,
                            height: 38.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.18),
                            ),
                            child: const Icon(
                              Icons.arrow_back_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),

                        // Title & Employee Count Subtitle
                        Column(
                          children: [
                            Text(
                              "User Management".tr(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            BlocBuilder<EmployeeCubit, EmployeeState>(
                              builder: (context, state) {
                                final cubit = context.watch<EmployeeCubit>();
                                final count = cubit.totalEmployeesCount ?? 0;
                                return Text(
                                  "{} employees".tr(args: [count.toString()]),
                                  style: TextStyle(
                                    color: const Color(0xFFFDE68A),
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        // Action Buttons (Add User & Extra options)
                        Row(
                          children: [
                            // Selection mode toggle
                            if (widget.onSelectionModeToggled != null) ...[
                              GestureDetector(
                                onTap: widget.onSelectionModeToggled,
                                child: Container(
                                  width: 38.r,
                                  height: 38.r,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: widget.isSelectionMode
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.18),
                                  ),
                                  child: Icon(
                                    widget.isSelectionMode
                                        ? Icons.check
                                        : Icons.checklist_rounded,
                                    color: widget.isSelectionMode
                                        ? ColorsManger.primaryColor
                                        : Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                            ],

                            // Add User Plus Button
                            GestureDetector(
                              onTap: () {
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
                              child: Container(
                                width: 38.r,
                                height: 38.r,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.18),
                                ),
                                child: const Icon(
                                  Icons.add_rounded,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    SizedBox(height: 16.h),

                    // Search Pill Input Field
                    Container(
                      height: 44.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(22.r),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.25),
                        ),
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(color: Colors.white, fontSize: 14.sp),
                        cursorColor: Colors.white,
                        onChanged: (val) {
                          widget.onSearchQueryChanged?.call(val);
                          context.read<EmployeeCubit>().searchEmployee(name: val);
                        },
                        decoration: InputDecoration(
                          hintText: "Search by name or role...".tr(),
                          hintStyle: TextStyle(
                            color: Colors.white.withOpacity(0.65),
                            fontSize: 13.sp,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: Colors.white70,
                            size: 20,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                        ),
                      ),
                    ),

                    SizedBox(height: 14.h),

                    // Department Filter Chips Horizontal Scrolling Row
                    SizedBox(
                      height: 34.h,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _departments.length,
                        separatorBuilder: (context, index) => SizedBox(width: 8.w),
                        itemBuilder: (context, index) {
                          final dept = _departments[index];
                          final bool isSelected = _selectedDepartment == dept;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDepartment = dept;
                              });
                              widget.onDepartmentSelected?.call(
                                dept == "All" ? null : dept,
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white.withOpacity(0.18),
                                borderRadius: BorderRadius.circular(18.r),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.white.withOpacity(0.25),
                                ),
                              ),
                              child: Text(
                                dept == "All" ? "All".tr() : dept.tr(),
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFF7F1D1D)
                                      : Colors.white,
                                  fontSize: 13.sp,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }
}
