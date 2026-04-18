part of 'supervisor_news_cubit.dart';

@immutable
abstract class SupervisorNewsState {}

class SupervisorNewsInitial extends SupervisorNewsState {}

class GetAnnouncementLoading extends SupervisorNewsState {}

class GetAnnouncementSuccess extends SupervisorNewsState {
  final List<AnnouncementItem> announcements;

  GetAnnouncementSuccess({
    required this.announcements,
  });
}

class GetAnnouncementFailure extends SupervisorNewsState {
  final String error;

  GetAnnouncementFailure({required this.error});
}

class GetUserNewsLoading extends SupervisorNewsState {}

class GetUserNewsSuccess extends SupervisorNewsState {
  final List<UserNewsItem> userNews;
  final List<CompanyEventItem> companyEvents;

  GetUserNewsSuccess({
    required this.userNews,
    required this.companyEvents,
  });
}

class GetUserNewsFailure extends SupervisorNewsState {
  final String error;

  GetUserNewsFailure({required this.error});
}
