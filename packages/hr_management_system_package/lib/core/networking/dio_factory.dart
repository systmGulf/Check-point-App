import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../env/env.dart';
import '../core.dart';

class DioFactory {
  /// private constructor as I don't want to allow creating an instance of this class
  DioFactory._();

  static Dio? dio;
  static Dio getDio() {
    Duration timeOut = const Duration(seconds: 30);

    if (dio == null) {
      dio = Dio();
      dio!
        ..options.connectTimeout = timeOut
        ..options.receiveTimeout = timeOut;
      addDioHeaders();
      if (!kReleaseMode) {
        addDioInterceptor();
      }
      return dio!;
    } else {
      addDioHeaders();

      return dio!;
    }
  }

  static void addDioHeaders() async {
    dio?.options.baseUrl = Env.baseUrl;
    dio?.options.headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${ApiConstant.token}',
    };
  }

  static void addDioInterceptor() {
    dio?.interceptors.add(
      PrettyDioLogger(
        requestBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
  }
}
