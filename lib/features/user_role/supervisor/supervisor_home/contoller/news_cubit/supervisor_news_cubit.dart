import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:hr_management_system_package/core/networking/api_constant.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/supervisor_news_model/company_event_response.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/supervisor_news_model/supervisor_news_response.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/supervisor_news_model/user_news_response.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/repo/supervisor_news_repo/supervisor_news_repo.dart';

part 'supervisor_news_state.dart';

class SupervisorNewsCubit extends Cubit<SupervisorNewsState> {
  SupervisorNewsCubit(this.supervisorNewsRepo) : super(SupervisorNewsInitial());

  final SupervisorNewsRepo supervisorNewsRepo;

  Future<void> getAnnouncement() async {
    emit(GetAnnouncementLoading());
    final employeeId = ApiConstant.employeeId.trim();
    if (employeeId.isEmpty) {
      emit(GetAnnouncementFailure(error: 'Employee id not found'));
      return;
    }
    final result = await supervisorNewsRepo.getAnnouncement(
      employeeId: employeeId,
    );

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(GetAnnouncementFailure(error: failure.message));
      },
      (announcements) {
        if (isClosed) return;
        emit(GetAnnouncementSuccess(announcements: announcements));
      },
    );
  }

  Future<void> getUserNews() async {
    emit(GetUserNewsLoading());
    final employeeId = ApiConstant.employeeId.trim();
    if (employeeId.isEmpty) {
      emit(GetUserNewsFailure(error: 'Employee id not found'));
      return;
    }
    final userNewsResult = await supervisorNewsRepo.getUserNews();
    final companyEventResult = await supervisorNewsRepo.getCompanyEvents(
      employeeId: employeeId,
    );

    userNewsResult.fold(
      (failure) {
        if (isClosed) return;
        emit(GetUserNewsFailure(error: failure.message));
      },
      (userNews) {
        companyEventResult.fold(
          (failure) {
            if (isClosed) return;
            emit(GetUserNewsFailure(error: failure.message));
          },
          (companyEvents) {
            if (isClosed) return;
            emit(
              GetUserNewsSuccess(
                userNews: userNews,
                companyEvents: companyEvents,
              ),
            );
          },
        );
      },
    );
  }
}
