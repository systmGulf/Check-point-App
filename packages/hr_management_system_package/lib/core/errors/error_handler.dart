import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';

import 'custom_exception.dart';

class Failure {
  final int code; // 200, 201, 400, 303..500 and so on
  final String message; // error , success

  const Failure(this.code, this.message);
}

class ErrorHandler implements Exception {
  final Failure failure;

  ErrorHandler.handle(Object error) : failure = mapExceptionToFailure(error);

  static Failure responseFailure(
    Map<String, dynamic> result, {
    int fallbackCode = ResponseCode.badRequest,
    String? fallbackMessage,
  }) {
    final statusCode = result['status'];
    final resolvedCode = statusCode is int ? statusCode : fallbackCode;
    final resolvedMessage = getResponseError(result);

    return Failure(
      resolvedCode,
      resolvedMessage == 'Something went wrong' && fallbackMessage != null
          ? fallbackMessage
          : resolvedMessage,
    );
  }

  static Failure unexpectedFailure({
    String? message,
    int code = ResponseCode.unexpectedError,
  }) {
    return Failure(code, message ?? ResponseMessage.unexpectedError);
  }
}

enum DataSource {
  success,
  noContent,
  badRequest,
  forbidden,
  unauthorised,
  notFound,
  internalServerError,
  connectTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  conflict,
  badCertificate,
  parsingError,
  defaultError
}

Failure mapExceptionToFailure(Object error) {
  if (error is Failure) {
    return error;
  }

  if (error is DioException) {
    return fromDioException(error);
  }

  if (error is BadRequestException) {
    return DataSource.badRequest.getFailure(message: error.message);
  }

  if (error is UnauthorizedException) {
    return DataSource.unauthorised.getFailure(message: error.message);
  }

  if (error is NotFoundException) {
    return DataSource.notFound.getFailure(message: error.message);
  }

  if (error is ConflictException) {
    return DataSource.conflict.getFailure(message: error.message);
  }

  if (error is InternalServerErrorException) {
    return DataSource.internalServerError.getFailure(message: error.message);
  }

  if (error is NoInternetConnectionException) {
    return DataSource.noInternetConnection.getFailure(message: error.message);
  }

  if (error is FetchDataException) {
    return DataSource.connectTimeout.getFailure(message: error.message);
  }

  if (error is CacheException) {
    return DataSource.cacheError.getFailure();
  }

  if (error is SocketException) {
    return DataSource.noInternetConnection.getFailure();
  }

  if (error is TimeoutException) {
    return DataSource.connectTimeout.getFailure();
  }

  if (error is FormatException || error is TypeError) {
    return DataSource.parsingError.getFailure();
  }

  if (error is ServerException) {
    return Failure(ResponseCode.defaultError,
        error.message ?? ResponseMessage.defaultError);
  }

  return const Failure(
    ResponseCode.unexpectedError,
    ResponseMessage.unexpectedError,
  );
}

Failure fromDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.connectTimeout.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.sendTimeout.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.receiveTimeout.getFailure();
    case DioExceptionType.badResponse:
      final response = error.response;
      final statusCode = response?.statusCode;
      final responseData = response?.data;
      final backendMessage = responseData is Map<String, dynamic>
          ? getResponseError(responseData)
          : response?.statusMessage;

      if (statusCode != null) {
        switch (statusCode) {
          case ResponseCode.badRequest:
            return DataSource.badRequest.getFailure(message: backendMessage);
          case ResponseCode.unauthorised:
            return DataSource.unauthorised.getFailure(message: backendMessage);
          case ResponseCode.forbidden:
            return DataSource.forbidden.getFailure(message: backendMessage);
          case ResponseCode.notFound:
            return DataSource.notFound.getFailure(message: backendMessage);
          case ResponseCode.conflict:
            return DataSource.conflict.getFailure(message: backendMessage);
          case ResponseCode.internalServerError:
            return DataSource.internalServerError
                .getFailure(message: backendMessage);
          default:
            return Failure(
              statusCode,
              backendMessage?.isNotEmpty == true
                  ? backendMessage!
                  : ResponseMessage.defaultError,
            );
        }
      }
      return DataSource.defaultError.getFailure();
    case DioExceptionType.cancel:
      return DataSource.cancel.getFailure();
    case DioExceptionType.unknown:
      return DataSource.defaultError.getFailure();
    case DioExceptionType.badCertificate:
      return DataSource.badCertificate.getFailure();

    case DioExceptionType.connectionError:
      return DataSource.noInternetConnection.getFailure();
  }
}

extension DataSourceExtension on DataSource {
  Failure getFailure({String? message}) {
    switch (this) {
      case DataSource.success:
        return Failure(
            ResponseCode.success, message ?? ResponseMessage.success);
      case DataSource.noContent:
        return Failure(
            ResponseCode.noContent, message ?? ResponseMessage.noContent);
      case DataSource.badRequest:
        return Failure(
            ResponseCode.badRequest, message ?? ResponseMessage.badRequest);
      case DataSource.forbidden:
        return Failure(
            ResponseCode.forbidden, message ?? ResponseMessage.forbidden);
      case DataSource.unauthorised:
        return Failure(
            ResponseCode.unauthorised, message ?? ResponseMessage.unauthorised);
      case DataSource.notFound:
        return Failure(
            ResponseCode.notFound, message ?? ResponseMessage.notFound);
      case DataSource.internalServerError:
        return Failure(ResponseCode.internalServerError,
            message ?? ResponseMessage.internalServerError);
      case DataSource.connectTimeout:
        return Failure(ResponseCode.connectTimeout,
            message ?? ResponseMessage.connectTimeout);
      case DataSource.cancel:
        return Failure(ResponseCode.cancel, message ?? ResponseMessage.cancel);
      case DataSource.receiveTimeout:
        return Failure(ResponseCode.receiveTimeout,
            message ?? ResponseMessage.receiveTimeout);
      case DataSource.sendTimeout:
        return Failure(
            ResponseCode.sendTimeout, message ?? ResponseMessage.sendTimeout);
      case DataSource.cacheError:
        return Failure(
            ResponseCode.cacheError, message ?? ResponseMessage.cacheError);
      case DataSource.noInternetConnection:
        return Failure(ResponseCode.noInternetConnection,
            message ?? ResponseMessage.noInternetConnection);
      case DataSource.conflict:
        return Failure(
            ResponseCode.conflict, message ?? ResponseMessage.conflict);
      case DataSource.badCertificate:
        return Failure(ResponseCode.badCertificate,
            message ?? ResponseMessage.badCertificate);
      case DataSource.parsingError:
        return Failure(
            ResponseCode.parsingError, message ?? ResponseMessage.parsingError);
      case DataSource.defaultError:
        return Failure(
            ResponseCode.defaultError, message ?? ResponseMessage.defaultError);
    }
  }
}

class ResponseCode {
  static const int success = 200; // success with data
  static const int noContent = 201; // success with no data (no content)
  static const int badRequest = 400; // failure, API rejected request
  static const int unauthorised = 401; // failure, user is not authorised
  static const int forbidden = 403; //  failure, API rejected request
  static const int conflict = 409; // failure, resource conflict
  static const int internalServerError = 500; // failure, crash in server side
  static const int notFound = 404; // failure, not found

  // local status code
  static const int connectTimeout = -1;
  static const int cancel = -2;
  static const int receiveTimeout = -3;
  static const int sendTimeout = -4;
  static const int cacheError = -5;
  static const int noInternetConnection = -6;
  static const int badCertificate = -7;
  static const int parsingError = -8;
  static const int defaultError = -9;
  static const int unexpectedError = -10;
}

class ResponseMessage {
  static const String success = "success"; // success with data
  static const String noContent =
      "success"; // success with no data (no content)
  static const String badRequest =
      "Bad request, Try again later"; // failure, API rejected request
  static const String unauthorised =
      "User is unauthorised, Try again later"; // failure, user is not authorised
  static const String forbidden =
      "Forbidden request, Try again later"; //  failure, API rejected request
  static const String conflict =
      "Conflict occurred, Try again later"; // failure, conflicting request
  static const String internalServerError =
      "Some thing went wrong, Try again later"; // failure, crash in server side
  static const String notFound =
      "Some thing went wrong, Try again later"; // failure, crash in server side

  // local status code
  static const String connectTimeout = "Time out error, Try again later";
  static const String cancel = "Request was cancelled, Try again later";
  static const String receiveTimeout = "Time out error, Try again later";
  static const String sendTimeout = "Time out error, Try again later";
  static const String cacheError = "Cache error, Try again later";
  static const String noInternetConnection =
      "Please check your internet connection";
  static const String badCertificate =
      "Could not verify the server certificate";
  static const String parsingError = "Received invalid data, Try again later";
  static const String defaultError = "Some thing went wrong, Try again later";
  static const String unexpectedError = "Unexpected error";
}

class ApiInternalStatus {
  static const int success = 0;
  static const int failure = 1;
}

String getResponseError(Map<String, dynamic> result) {
  if (result['errors'] != null && result['errors'].isNotEmpty) {
    return (result['errors'] as List).join('\n');
  } else if (result['validationErrors'] != null &&
      result['validationErrors'].isNotEmpty) {
    return (((result['validationErrors'] as List).first)
        as Map<String, dynamic>)['errorMessage'];
  } else {
    return "Something went wrong";
  }
}
