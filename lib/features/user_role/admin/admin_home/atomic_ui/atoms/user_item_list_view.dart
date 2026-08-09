import 'package:easy_localization/easy_localization.dart';
import 'package:employee_mangement/core/widgets/user_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/hr_manamgement_system_package.dart';

import '../../../../../../core/dependency%D9%80injection/register%D9%80factory.dart';
import '../../../../../../core/helpers/extention.dart';
import '../../../../../../core/improvements/assign_shift_to_employees_bottom_sheet.dart';
import '../../../../../../core/styles/colors.dart';
import '../../controllers/mange_employee_cubit/employee_cubit.dart';
import '../../controllers/shifts_and_polices_cubit/shifts_and_polices_cubit.dart';
import '../enitities/user_item_entity.dart';
import '../pages/edit_user_screen.dart';

class UserItemListView extends StatelessWidget {
  const UserItemListView({
    super.key,
    required this.userItemEntity,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.onSelectedChanged,
  });

  final UserItemEntity userItemEntity;
  final bool isSelected;
  final bool isSelectionMode;
  final ValueChanged<bool?>? onSelectedChanged;

  String _getInitials(String name) {
    if (name.trim().isEmpty) return "US";
    final parts = name.trim().split(' ');
    if (parts.length >= 2 && parts[0].isNotEmpty && parts[1].isNotEmpty) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts[0].length >= 2) {
      return parts[0].substring(0, 2).toUpperCase();
    } else if (parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return "US";
  }

  Map<String, Color> _getAvatarColors(String name) {
    final List<Map<String, Color>> colorPalette = [
      {'bg': const Color(0xFFEEF2FF), 'text': const Color(0xFF4F46E5)},
      {'bg': const Color(0xFFF3E8FF), 'text': const Color(0xFF9333EA)},
      {'bg': const Color(0xFFECFDF5), 'text': const Color(0xFF059669)},
      {'bg': const Color(0xFFFEF3C7), 'text': const Color(0xFFD97706)},
      {'bg': const Color(0xFFFFE4E6), 'text': const Color(0xFFE11D48)},
      {'bg': const Color(0xFFE0F2FE), 'text': const Color(0xFF0284C7)},
    ];
    final int hash = name.codeUnits.fold(0, (prev, elem) => prev + elem);
    return colorPalette[hash % colorPalette.length];
  }

  @override
  Widget build(BuildContext context) {
    final initials = _getInitials(userItemEntity.userName.isNotEmpty ? userItemEntity.userName : userItemEntity.name);
    final avatarColors = _getAvatarColors(userItemEntity.userName);
    final bool hasShift = userItemEntity.shiftName.isNotEmpty && userItemEntity.shiftName != 'No Shift Assigned';
    final String employeeCode = userItemEntity.userId.length > 6
        ? 'EMP-${userItemEntity.userId.substring(0, 4).toUpperCase()}'
        : 'EMP-${userItemEntity.userId}';

    return GestureDetector(
      onLongPress: () {
        if (onSelectedChanged != null) {
          onSelectedChanged!(!isSelected);
        }
      },
      onTap: () {
        if (isSelectionMode) {
          if (onSelectedChanged != null) {
            onSelectedChanged!(!isSelected);
          }
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(
            color: isSelected
                ? ColorsManger.primaryColor
                : const Color(0xFFF3F4F6),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isSelectionMode) ...[
              Checkbox(
                value: isSelected,
                activeColor: ColorsManger.primaryColor,
                onChanged: onSelectedChanged,
              ),
              SizedBox(width: 8.w),
            ],

            // Avatar Section
            userItemEntity.imageUrl.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: UserImage(
                      height: 48.r,
                      imageUrl: userItemEntity.imageUrl,
                    ),
                  )
                : Container(
                    width: 48.r,
                    height: 48.r,
                    decoration: BoxDecoration(
                      color: avatarColors['bg'],
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: avatarColors['text'],
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

            SizedBox(width: 14.w),

            // Middle Column details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Name
                  Text(
                    userItemEntity.userName.isNotEmpty ? userItemEntity.userName : userItemEntity.name,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF1F2937),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),

                  // Position / Role
                  Text(
                    userItemEntity.position.isNotEmpty
                        ? userItemEntity.position.tr()
                        : (userItemEntity.role.isNotEmpty
                            ? userItemEntity.role.tr()
                            : 'Employee'.tr()),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6.h),

                  // Tags Row (Department & Employee Code)
                  Row(
                    children: [
                      if (userItemEntity.department.isNotEmpty) ...[
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEEF2FF),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              userItemEntity.department.tr(),
                              style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF4F46E5),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                      ],
                      Text(
                        employeeCode,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: const Color(0xFF9CA3AF),
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Right side (Status badge & 3-dots Menu)
            if (!isSelectionMode)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: hasShift ? const Color(0xFFECFDF5) : const Color(0xFFF3E8FF),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6.r,
                          height: 6.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: hasShift ? const Color(0xFF10B981) : const Color(0xFF9333EA),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          hasShift ? 'Active'.tr() : 'On Leave'.tr(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                            color: hasShift ? const Color(0xFF059669) : const Color(0xFF7E22CE),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // 3-dots Options Menu button
                  GestureDetector(
                    onTap: () => _showUserActionMenu(context),
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFF3F4F6),
                      ),
                      child: Icon(
                        Icons.more_horiz_rounded,
                        color: const Color(0xFF6B7280),
                        size: 20.sp,
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _showUserActionMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (bottomCtx) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 36.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  userItemEntity.userName.isNotEmpty ? userItemEntity.userName : userItemEntity.name,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 14.h),

                // Edit Option
                ListTile(
                  leading: const Icon(Icons.edit_outlined, color: Color(0xFF2563EB)),
                  title: Text('Edit User'.tr()),
                  onTap: () {
                    Navigator.pop(bottomCtx);
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => getIt<EmployeeCubit>(),
                          child: EditUser(userItemEntity: userItemEntity),
                        ),
                      ),
                    ).then((_) {
                      context.read<EmployeeCubit>().getAllEmployees(pageNumber: 0, itemCount: 10);
                    });
                  },
                ),

                // Assign Shift Option
                ListTile(
                  leading: const Icon(Icons.schedule_outlined, color: Color(0xFF059669)),
                  title: Text('Assign Shift'.tr()),
                  onTap: () {
                    Navigator.pop(bottomCtx);
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (sheetCtx) {
                        return MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: context.read<ShiftsAndPolicesCubit>(),
                            ),
                          ],
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(sheetCtx).viewInsets.bottom,
                            ),
                            child: AssignShiftToEmployeesBottomSheet(
                              employeeIds: [userItemEntity.userId],
                              onSuccess: () {
                                context.read<EmployeeCubit>().getAllEmployees(pageNumber: 0, itemCount: 10);
                              },
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

                // Delete Option
                ListTile(
                  leading: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
                  title: Text(
                    'Delete User'.tr(),
                    style: const TextStyle(color: Color(0xFFEF4444)),
                  ),
                  onTap: () {
                    Navigator.pop(bottomCtx);
                    userItemEntity.onDelete();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
