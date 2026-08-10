import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hr_management_system_package/core/core.dart';
import 'package:hr_management_system_package/core/errors/status_code.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'api_service_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  group('ApiService', () {
    late MockDio mockDio;
    late ApiService apiService;

    setUp(() {
      mockDio = MockDio();
      apiService = ApiService(dio: mockDio);
    });

    test('post returns response data on success', () async {
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(
                    path: 'Employee', baseUrl: 'http://ems.runasp.net/api/'),
                statusCode: 200,
                data: {"data": {}},
              ));
      final response = await apiService.post(endPoint: 'Employee', body: {});
      expect(response, isA<Map<String, dynamic>>());
    });

    test('post throws existing failure for non-dio errors', () async {
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(Failure(404, 'error'));

      expect(
        () => apiService.post(endPoint: 'Employee', body: {}),
        throwsA(
          isA<Failure>()
              .having((failure) => failure.code, 'code', 404)
              .having((failure) => failure.message, 'message', 'error'),
        ),
      );
    });

    test('post throws mapped failure for dio bad response', () async {
      when(mockDio.post(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'Employee'),
          response: Response(
            requestOptions: RequestOptions(path: 'Employee'),
            statusCode: StatusCode.notFound,
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(
        () => apiService.post(endPoint: 'Employee', body: {}),
        throwsA(
          isA<Failure>()
              .having((failure) => failure.code, 'code', ResponseCode.notFound),
        ),
      );
    });

    test('put returns response data on success', () async {
      when(mockDio.put(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(
                    path: 'Employee', baseUrl: 'http://ems.runasp.net/api/'),
                statusCode: 200,
                data: {"data": {}},
              ));
      final response = await apiService.put(endPoint: 'Employee', body: {});
      expect(response, isA<Map<String, dynamic>>());
    });

    test('get returns response data on success', () async {
      when(mockDio.get(any, options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(
                    path: 'Employee', baseUrl: 'http://ems.runasp.net/api/'),
                statusCode: 200,
                data: {"data": {}},
              ));
      final response = await apiService.get(endPoint: 'Employee');
      expect(response, isA<Map<String, dynamic>>());
    });

    test('delete returns response data on success', () async {
      when(mockDio.delete(any, options: anyNamed('options')))
          .thenAnswer((_) async => Response(
                requestOptions: RequestOptions(
                    path: 'Employee', baseUrl: 'http://ems.runasp.net/api/'),
                statusCode: 200,
                data: {"data": {}},
              ));
      final response = await apiService.delete(endPoint: 'Employee');
      expect(response, isA<Map<String, dynamic>>());
    });

    test('get throws no internet failure for connection errors', () async {
      when(mockDio.get(any,
              data: anyNamed('data'), options: anyNamed('options')))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(path: 'Employee'),
          type: DioExceptionType.connectionError,
        ),
      );

      expect(
        () => apiService.get(endPoint: 'Employee'),
        throwsA(
          isA<Failure>().having(
            (failure) => failure.code,
            'code',
            ResponseCode.noInternetConnection,
          ),
        ),
      );
    });
  });
}
