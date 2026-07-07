part of 'upload_user_image_cubit.dart';

abstract class UploadUserImageState {}

final class UploadUserImageInitial extends UploadUserImageState {}

final class UploadUserImageSuccess extends UploadUserImageState {}

final class UploadUserImageError extends UploadUserImageState {
  final String message;
  UploadUserImageError({required this.message});
}

final class UploadUserImageLoading extends UploadUserImageState {}
