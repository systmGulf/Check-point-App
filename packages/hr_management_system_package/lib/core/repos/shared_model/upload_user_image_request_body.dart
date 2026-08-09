import 'package:freezed_annotation/freezed_annotation.dart';

part 'upload_user_image_request_body.g.dart';
@JsonSerializable()
class UploadUserImageRequestBody {
 final String? employeeImageUrl;
  final String? employeeId;

  UploadUserImageRequestBody({this.employeeImageUrl, this.employeeId});


  Map<String, dynamic> toJson() => _$UploadUserImageRequestBodyToJson(this);
}