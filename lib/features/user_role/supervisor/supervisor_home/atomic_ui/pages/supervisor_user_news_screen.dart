import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/styles/styles.dart';
import '../../contoller/news_cubit/supervisor_news_cubit.dart';
import '../widgets/announcement_state_view.dart';
import '../widgets/news_loading_skeleton.dart';
import '../widgets/user_news_list_view.dart';

class SupervisorUserNewsScreen extends StatelessWidget {
  const SupervisorUserNewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SupervisorNewsCubit>();

    return BlocBuilder<SupervisorNewsCubit, SupervisorNewsState>(
      builder: (context, state) {
        if (state is GetUserNewsLoading) {
          return NewsLoadingSkeleton(
            onRefresh: cubit.getUserNews,
          );
        }

        if (state is GetUserNewsFailure) {
          return AnnouncementStateView(
            onRefresh: cubit.getUserNews,
            child: Text(
              state.error,
              style: AppStylesManger.font14BoldRed,
              textAlign: TextAlign.center,
            ),
          );
        }

        if (state is GetUserNewsSuccess) {
          if (state.userNews.isEmpty && state.companyEvents.isEmpty) {
            return AnnouncementStateView(
              onRefresh: cubit.getUserNews,
              child: Text(
                'No user news or events available',
                style: AppStylesManger.font15RegularGrey,
              ),
            );
          }

          return UserNewsListView(
            userNews: state.userNews,
            companyEvents: state.companyEvents,
            onRefresh: cubit.getUserNews,
          );
        }

        return AnnouncementStateView(
          onRefresh: cubit.getUserNews,
          child: const Text(''),
        );
      },
    );
  }
}
