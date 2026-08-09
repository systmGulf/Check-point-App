import 'package:flutter_test/flutter_test.dart';
import 'package:hr_management_system_package/core/notifications/send_multiple_notifications_request_body.dart';
import 'package:hr_management_system_package/core/notifications/send_single_notification_request_body.dart';
import 'package:hr_management_system_package/core/repos/shared_model/upload_user_image_request_body.dart';
import 'package:hr_management_system_package/register_account/models/register_account_request_body.dart';
import 'package:hr_management_system_package/role_login/data/model/employee_login_model/update_user_token_request_body.dart';
import 'package:hr_management_system_package/role_login/data/model/employee_login_model/role_login_request_body.dart';

void main() {
  group('Shared and auth request bodies', () {
    test('UploadUserImageRequestBody serializes nullable fields', () {
      final body = UploadUserImageRequestBody(
        employeeImageUrl: 'https://cdn/image.png',
        employeeId: '42',
      );

      expect(body.toJson(), {
        'employeeImageUrl': 'https://cdn/image.png',
        'employeeId': '42',
      });
    });

    test('RegisterAccountRequestBody serializes expected keys', () {
      final body = RegisterAccountRequestBody(
        name: 'New User',
        mobileId: 'mobile-id',
        deviceToken: 'fcm-token',
      );

      expect(body.toJson(), {
        'name': 'New User',
        'mobileId': 'mobile-id',
        'deviceToken': 'fcm-token',
      });
    });

    test('RoleLoginRequestBody uses backend userName key', () {
      final body = RoleLoginRequestBody(
        email: 'user@example.com',
        password: 'secret',
        mobileId: 'mobile-id',
        role: 'employee',
      );

      expect(body.toJson(), {
        'userName': 'user@example.com',
        'password': 'secret',
        'mobileId': 'mobile-id',
        'role': 'employee',
      });
    });

    test('UpdateUserTokenRequestBody serializes token sync payload', () {
      final body = UpdateUserTokenRequestBody(
        userId: 'emp-44',
        deviceTokens: ['token-1'],
      );

      expect(body.toJson(), {
        'userId': 'emp-44',
        'deviceTokens': ['token-1'],
      });
    });

    test('SendSingleNotificationRequestBody serializes notification payload', () {
      final body = SendSingleNotificationRequestBody(
        deviceToken: 'fcm-1',
        title: 'Title',
        body: 'Message',
      );

      expect(body.toJson(), {
        'deviceToken': 'fcm-1',
        'title': 'Title',
        'body': 'Message',
      });
    });

    test('SendMultipleNotificationsRequestBody serializes notification list payload', () {
      final body = SendMultipleNotificationsRequestBody(
        deviceTokens: ['fcm-1', 'fcm-2'],
        title: 'Alert',
        body: 'Broadcast',
        topic: 'ops',
      );

      expect(body.toJson(), {
        'deviceTokens': ['fcm-1', 'fcm-2'],
        'title': 'Alert',
        'body': 'Broadcast',
        'topic': 'ops',
      });
    });
  });
}
