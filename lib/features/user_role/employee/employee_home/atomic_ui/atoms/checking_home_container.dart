import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CheckingHomeContainer extends StatelessWidget {
  const CheckingHomeContainer({
    super.key,
    required this.image,
    required this.string,
    required this.color,
    required this.iconColor,
    required this.time,
  });
  final String image, string;
  final Color color, iconColor;
  final String time;

  @override
  Widget build(BuildContext context) {
    // Check if Check In or Check Out based on the label string
    final isCheckIn = string.toLowerCase().contains('in') || string.contains('حضور');

    final Color themeColor = isCheckIn ? Colors.green.shade700 : Colors.red.shade700;
    final Color iconBgColor = isCheckIn ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE);
    final IconData iconData = isCheckIn ? Icons.login_rounded : Icons.logout_rounded;

    return Container(
      height: 152.h,
      width: 152.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: themeColor.withOpacity(0.3), width: 1.2),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: iconBgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: themeColor,
              size: 24.sp,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            string,
            style: TextStyle(
              color: themeColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (time.isNotEmpty && time != '00:00' && time != '--' && time != 'null' && time != '09:00 AM' && time != '05:00 PM') ...[
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
