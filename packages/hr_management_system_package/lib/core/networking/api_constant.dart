class ApiConstant {
  static String token = "";
  static String username = '';
  static String employeeId = '';
  static String departmentId = '';
  static String branchId = '';
  static String position = '';
  static String employeeCheckinTime = '';
  static String employeeCheckoutTime = '';
  static String imageUrl = '';
  static String shiftName = '';
  static String area = 'Customer';
  static const String login = "Auth/Login";
  static const String uploadUserImage = "employeeImage";
  static const String updateUserToken = "Auth/updateDeviceToken";
  static const successApiKey = 'isSuccess';
  static const singleNotification = 'sendSingle';
  static const multiNotification = 'sendMulti';

  static const String employee = "Employee";
  static const String employeeCheckIn = 'Attendance/in';
  static const String employeeCheckInWithoutPlan = 'Attendance/inWithoutPlan';
  static const String employeeCheckOut = 'Attendance/out';
  static const String employeeCheckOutWithoutPlan = 'Attendance/outWithoutPlan';
  static const String getEmployeeAttendanceHistory = 'Attendance/employeeId';
  static const String leaveRequest = 'LeaveRequest';
  static const String getAllLeaveRequestsForEmployee = 'LeaveRequest/employeeId';
  static const String getEmployeeAttendance = 'Attendance';
  static const String employeeChangePassword = 'Auth/ChangePassword';
  static const String deleteEmployee = 'Auth/DeleteUser';
  static const String department = 'Department';
  static const String removeTaskFromEmployee = "Employee/removeAssignTask";
  static const String addCustomer = 'Customer';
  static const String customerplan = 'customerPlan';
  static const String branches = 'Branch';
  static const String accountRequest = 'AccountRequest';
  static const String plan = 'Plan';
  static const String task = 'Task';
  static const String shift = 'Shift';
  static const String notification = 'Notification';
  static const String policy = 'Policy';
  static const String trackEmployeeLocation = 'Employee/trackEmployee';
  static const String planFeedback = 'Feedback';
  static const String getTrackingSummaryForEmployee =
      'Employee/getEmployeeTracking';
  static const String removeAsignPolicy = "Employee/removeAssignPolicy";
  static const String removeAsignCustomerPlan =
      "Employee/removeAssignCustomerPlan";
  static const String feedBackStatus = "Feedback/feedbackStatus";
}
