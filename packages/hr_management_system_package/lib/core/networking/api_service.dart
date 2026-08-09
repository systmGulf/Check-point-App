import 'package:dio/dio.dart';

import '../../hr_manamgement_system_package.dart';

class ApiService {
  final Dio _dio;

  ApiService({required Dio dio}) : _dio = dio;

  Future<dynamic> post({
    required String endPoint,
    required Map<String, dynamic> body,
  }) {
    return _runRequest(
      () => _dio.post(
        endPoint,
        data: body,
        options: _buildOptions(),
      ),
    );
  }

  Future<dynamic> get({
    required String endPoint,
    Map<String, dynamic>? body,
  }) {
    return _runRequest(
      () => _dio.get(
        endPoint,
        data: body,
        options: _buildOptions(),
      ),
    );
  }

  Future<dynamic> put({
    required String endPoint,
    required Map<String, dynamic> body,
  }) {
    return _runRequest(
      () => _dio.put(
        endPoint,
        data: body,
        options: _buildOptions(),
      ),
    );
  }

  Future<dynamic> delete({required String endPoint}) {
    return _runRequest(
      () => _dio.delete(
        endPoint,
        options: _buildOptions(),
      ),
    );
  }

  Future<dynamic> _runRequest(
      Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      return response.data;
    } on DioException catch (error) {
      throw fromDioException(error);
    } on Object catch (error) {
      if (error is Failure) {
        rethrow;
      }
      throw ErrorHandler.unexpectedFailure();
    }
  }

  Options _buildOptions() {
    return Options(
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer ${ApiConstant.token}',
      },
    );
  }
}
