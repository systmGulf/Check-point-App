part of 'shareattendance_cubit.dart';

@immutable
abstract class ShareattendanceState {}

class ShareAttAndanceInitial extends ShareattendanceState {}

class ShareAttAndanceLoading extends ShareattendanceState {}

class ShareAttAndanceSuccess extends ShareattendanceState {}

class ShareAttAndanceFailure extends ShareattendanceState {
  final String er;
  ShareAttAndanceFailure({required this.er});
}

