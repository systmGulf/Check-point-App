import 'package:flutter_test/flutter_test.dart';
import 'package:hr_management_system_package/auth.dart';

void main() {
  test('RoleLoginModel parses nested login payloads', () {
    final model = RoleLoginModel.fromJson({
      'value': {
        'id': '12',
        'userName': 'osama',
        'name': 'Osama',
        'roles': ['employee'],
        'token': 'secret-token',
      },
      'status': 200,
      'isSuccess': true,
      'successMessage': 'ok',
      'correlationId': 'corr-id',
      'errors': <dynamic>[],
      'validationErrors': <dynamic>[],
    });

    expect(model.isSuccess, isTrue);
    expect(model.value?.id, '12');
    expect(model.value?.roles, ['employee']);
    expect(model.value?.token, 'secret-token');
  });
}
