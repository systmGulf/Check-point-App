// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_user_image_request_body.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadUserImageRequestBody _$UploadUserImageRequestBodyFromJson(
        Map<String, dynamic> json) =>
    UploadUserImageRequestBody(
      employeeImageUrl: json['employeeImageUrl'] as String?,
      employeeId: json['employeeId'] as String?,
    );

Map<String, dynamic> _$UploadUserImageRequestBodyToJson(
        UploadUserImageRequestBody instance) =>
    <String, dynamic>{
      'employeeImageUrl': instance.employeeImageUrl,
      'employeeId': instance.employeeId,
    };
