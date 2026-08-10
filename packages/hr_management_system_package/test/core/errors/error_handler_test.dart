import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hr_management_system_package/core/core.dart';
import 'package:hr_management_system_package/core/errors/custom_exception.dart';

void main() {
  group('ErrorHandler', () {
    test('maps connection errors to no internet failure', () {
      final failure = ErrorHandler.handle(
        DioException(
          requestOptions: RequestOptions(path: '/attendance'),
          type: DioExceptionType.connectionError,
        ),
      ).failure;

      expect(failure.code, ResponseCode.noInternetConnection);
      expect(failure.message, ResponseMessage.noInternetConnection);
    });

    test('uses response status and message for bad responses', () {
      final failure = ErrorHandler.handle(
        DioException(
          requestOptions: RequestOptions(path: '/attendance'),
          response: Response(
            requestOptions: RequestOptions(path: '/attendance'),
            statusCode: 422,
            data: {
              'errors': ['Validation failed'],
            },
          ),
          type: DioExceptionType.badResponse,
        ),
      ).failure;

      expect(failure.code, 422);
      expect(failure.message, 'Validation failed');
    });

    test('maps custom server exceptions to typed failures', () {
      final failure = ErrorHandler.handle(const NotFoundException()).failure;

      expect(failure.code, ResponseCode.notFound);
      expect(failure.message, 'Requested Info Not Found');
    });

    test('passes through existing failures unchanged', () {
      final failure = ErrorHandler.handle(Failure(999, 'custom')).failure;

      expect(failure.code, 999);
      expect(failure.message, 'custom');
    });

    test('maps format exceptions to parsing failures', () {
      final failure = ErrorHandler.handle(
        const FormatException('invalid json'),
      ).failure;

      expect(failure.code, ResponseCode.parsingError);
      expect(failure.message, ResponseMessage.parsingError);
    });

    test('maps unknown objects to unexpected failure', () {
      final failure = ErrorHandler.handle(Object()).failure;

      expect(failure.code, ResponseCode.unexpectedError);
      expect(failure.message, ResponseMessage.unexpectedError);
    });

    test('extracts validation and list errors from api payloads', () {
      expect(
        getResponseError({
          'validationErrors': [
            {'errorMessage': 'Employee id is required'},
          ],
        }),
        'Employee id is required',
      );

      expect(
        getResponseError({
          'errors': ['First error', 'Second error'],
        }),
        'First error\nSecond error',
      );
    });
  });
}
