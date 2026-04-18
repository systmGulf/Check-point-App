import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/styles/styles.dart';
import '../../../../../../core/widgets/build_custom_app_bar.dart';
import '../../contoller/news_cubit/supervisor_news_cubit.dart';
import '../widgets/announcement_list_view.dart';
import '../widgets/news_loading_skeleton.dart';
import '../widgets/announcement_state_view.dart';

class SupervisorAnnouncementScreen extends StatelessWidget {
  const SupervisorAnnouncementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SupervisorNewsCubit>();

    return Scaffold(
      appBar: buildCustomAppBar(context, 'Announcements'),
      body: BlocBuilder<SupervisorNewsCubit, SupervisorNewsState>(
        builder: (context, state) {
          if (state is GetAnnouncementLoading) {
            return NewsLoadingSkeleton(
              onRefresh: cubit.getAnnouncement,
            );
          }

          if (state is GetAnnouncementFailure) {
            return AnnouncementStateView(
              onRefresh: cubit.getAnnouncement,
              child: Text(
                state.error,
                style: AppStylesManger.font14BoldRed,
                textAlign: TextAlign.center,
              ),
            );
          }

          if (state is GetAnnouncementSuccess) {
            if (state.announcements.isEmpty) {
              return AnnouncementStateView(
                onRefresh: cubit.getAnnouncement,
                child: Text(
                  'No announcements available',
                  style: AppStylesManger.font15RegularGrey,
                ),
              );
            }

            return AnnouncementListView(
              announcements: state.announcements,
              onRefresh: cubit.getAnnouncement,
            );
          }

          return AnnouncementStateView(
            onRefresh: cubit.getAnnouncement,
            child: const Text(''),
          );
        },
      ),
    );
  }
}
