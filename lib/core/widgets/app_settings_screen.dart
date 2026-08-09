import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hr_management_system_package/core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/extention.dart';
import '../routing/routes.dart';
import '../styles/colors.dart';
import '../widgets/build_change_language_bottom_sheet.dart';
import '../../features/user_role/employee/employee_home/controller/attendence/attendence_cubit.dart';

class AppSettingsScreen extends StatefulWidget {
  const AppSettingsScreen({super.key});

  @override
  State<AppSettingsScreen> createState() => _AppSettingsScreenState();
}

class _AppSettingsScreenState extends State<AppSettingsScreen> {
  bool _biometricEnabled = true;
  String _odooEmployeeId = '';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _biometricEnabled = prefs.getBool('biometric_enabled') ?? true;
      _odooEmployeeId = prefs.getString('odoo_employee_id') ?? '';
    });
  }

  Future<void> _updateSetting(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  Future<void> _showOdooIdDialog() async {
    final controller = TextEditingController(text: _odooEmployeeId);
    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Odoo Employee ID'.tr()),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: 'Enter Odoo Employee ID (e.g. 12)'.tr(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Cancel'.tr()),
            ),
            TextButton(
              onPressed: () async {
                final input = controller.text.trim();
                if (input.isNotEmpty && int.tryParse(input) == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a valid number'.tr())),
                  );
                  return;
                }
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('odoo_employee_id', input);
                setState(() {
                  _odooEmployeeId = input;
                });
                Navigator.pop(dialogContext);
              },
              child: Text('Save'.tr()),
            ),
          ],
        );
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final bool isArabic = context.locale.languageCode == 'ar';
    final String username = ApiConstant.username.isNotEmpty ? ApiConstant.username : 'User';
    final String initials = _getInitials(username);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Top Header Banner
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    ColorsManger.darkGreen,
                    ColorsManger.primaryColor,
                    ColorsManger.primaryColorLight,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(28.r),
                ),
                boxShadow: [
                  BoxShadow(
                    color: ColorsManger.darkGreen.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(18.w, 14.h, 18.w, 24.h),
                  child: Column(
                    children: [
                      // Header Title
                      Text(
                        'Settings'.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 18.h),

                      // User Profile Gradient Card
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              ColorsManger.primaryColor,
                              ColorsManger.darkGreen,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            Container(
                              width: 52.r,
                              height: 52.r,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  initials,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 14.w),

                            // Name & Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    username,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    "${username.toLowerCase().replaceAll(' ', '')}@checkpoint.io",
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 12.sp,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Settings Content List
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // GENERAL SETTINGS SECTION
                  _buildSectionTitle('General'.tr()),
                  _buildCardGroup([
                    _buildCustomTile(
                      icon: Icons.language_rounded,
                      iconBg: const Color(0xFFEEF2FF),
                      iconColor: const Color(0xFF4F46E5),
                      title: 'Language'.tr(),
                      subtitle: isArabic ? 'العربية' : 'English',
                      trailing: GestureDetector(
                        onTap: () => buildChangeLanguageBottomSheet(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'EN',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: !isArabic ? FontWeight.bold : FontWeight.normal,
                                  color: !isArabic ? ColorsManger.primaryColor : Colors.grey,
                                ),
                              ),
                              Text(' / ', style: TextStyle(color: Colors.grey, fontSize: 12.sp)),
                              Text(
                                'ع',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: isArabic ? FontWeight.bold : FontWeight.normal,
                                  color: isArabic ? ColorsManger.primaryColor : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),

                  SizedBox(height: 20.h),

                  // SECURITY SECTION
                  _buildSectionTitle('SECURITY'.tr()),
                  _buildCardGroup([
                    _buildSwitchTile(
                      icon: Icons.fingerprint_rounded,
                      iconBg: const Color(0xFFECFDF5),
                      iconColor: const Color(0xFF10B981),
                      title: 'Biometric Login'.tr(),
                      subtitle: 'Face ID / Fingerprint'.tr(),
                      value: _biometricEnabled,
                      onChanged: (val) {
                        setState(() => _biometricEnabled = val);
                        _updateSetting('biometric_enabled', val);
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    _buildActionTile(
                      icon: Icons.lock_outline_rounded,
                      iconBg: const Color(0xFFFFE4E6),
                      iconColor: const Color(0xFFE11D48),
                      title: 'Change Password'.tr(),
                      subtitle: 'Update your account password'.tr(),
                      onTap: () {
                        context.pushName(Routes.employeeChangePasswordScreen);
                      },
                    ),
                  ]),

                  SizedBox(height: 20.h),

                  // SUPPORT & LEGAL SECTION
                  _buildSectionTitle('SUPPORT'.tr()),
                  _buildCardGroup([
                    _buildActionTile(
                      icon: Icons.article_outlined,
                      iconBg: const Color(0xFFEEF2FF),
                      iconColor: const Color(0xFF4F46E5),
                      title: 'Terms & Conditions'.tr(),
                      subtitle: 'Terms of service and privacy policy'.tr(),
                      onTap: () {
                        context.pushName(Routes.termsAndConditionsScreen);
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    _buildActionTile(
                      icon: Icons.info_outline_rounded,
                      iconBg: const Color(0xFFE0F2FE),
                      iconColor: const Color(0xFF0284C7),
                      title: 'About Check-Point'.tr(),
                      subtitle: 'Version 1.0.1 (Build 241)',
                      onTap: () {},
                    ),
                  ]),

                  SizedBox(height: 28.h),

                  // SIGN OUT BUTTON
                  GestureDetector(
                    onTap: () => _handleLogout(context),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFFFCA5A5),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.logout_rounded,
                            color: Color(0xFFEF4444),
                            size: 20,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Sign Out'.tr(),
                            style: TextStyle(
                              color: const Color(0xFFEF4444),
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 16.h),

                  // Footer Copy
                  Center(
                    child: Text(
                      'Check-Point v1.0.1 · © 2026 Check-Point Inc.',
                      style: TextStyle(
                        color: const Color(0xFF9CA3AF),
                        fontSize: 11.sp,
                      ),
                    ),
                  ),

                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w, right: 4.w),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF6B7280),
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return _buildCustomTile(
      icon: icon,
      iconBg: iconBg,
      iconColor: iconColor,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        activeColor: Colors.white,
        activeTrackColor: ColorsManger.primaryColor,
        inactiveThumbColor: Colors.white,
        inactiveTrackColor: const Color(0xFFE5E7EB),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: _buildCustomTile(
        icon: icon,
        iconBg: iconBg,
        iconColor: iconColor,
        title: title,
        subtitle: subtitle,
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: Color(0xFF9CA3AF),
          size: 22,
        ),
      ),
    );
  }

  Widget _buildCustomTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required Widget trailing,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      child: Row(
        children: [
          // Left soft icon container
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),

          SizedBox(width: 14.w),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),

          trailing,
        ],
      ),
    );
  }

  Future<void> _handleLogout(BuildContext context) async {
    FlutterBackgroundService().invoke('stop');
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(
      AttendanceCubit.trackingEnabledKey,
      false,
    );
    await SecureCache.deleteFromCacheByKey(key: 'token');
    await SecureCache.deleteFromCacheByKey(key: 'username');
    await SecureCache.deleteFromCacheByKey(key: 'departmentId');
    await SecureCache.deleteFromCacheByKey(key: 'position');
    ApiConstant.token = await SecureCache.getFromCache(key: 'token');
    if (!context.mounted) return;
    context.pushReplacementName(Routes.userRoleScreen);
  }
}
