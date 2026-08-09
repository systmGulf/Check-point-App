import 'package:flutter_test/flutter_test.dart';
import 'package:hr_management_system_package/core/errors/custom_exception.dart';

void main() {
  group('Custom exceptions', () {
    test('ServerException exposes message via toString', () {
      const exception = ServerException('boom');

      expect(exception.toString(), 'boom');
      expect(exception.props, ['boom']);
    });

    test('typed exceptions keep their default messages', () {
      expect(const FetchDataException().message, 'Error During Communication');
      expect(const BadRequestException().message, 'Bad Request1');
      expect(const UnauthorizedException().message, 'Unauthorized');
      expect(const NotFoundException().message, 'Requested Info Not Found');
      expect(const ConflictException().message, 'Conflict Occurred');
      expect(
        const InternalServerErrorException().message,
        'Internal Server Error',
      );
      expect(
        const NoInternetConnectionException().message,
        'No Internet Connection',
      );
    });
  });
}
