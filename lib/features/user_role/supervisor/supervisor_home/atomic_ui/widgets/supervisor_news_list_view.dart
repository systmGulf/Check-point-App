import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/supervisor_news_model/supervisor_news_response.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/supervisor_news_model/user_news_response.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import 'announcement_card.dart';
import 'user_news_card.dart';

class SupervisorNewsListView extends StatelessWidget {
  const SupervisorNewsListView({
    super.key,
    required this.announcements,
    required this.userNews,
    required this.onRefresh,
  });

  final List<AnnouncementItem> announcements;
  final List<UserNewsItem> userNews;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (announcements.isNotEmpty) ...[
            Text('Announcements', style: AppStylesManger.font16BoldBlack),
            verticalSpace(8),
            ...announcements.map((item) => AnnouncementCard(item: item)),
            verticalSpace(6),
          ],
          if (userNews.isNotEmpty) ...[
            Text('User News', style: AppStylesManger.font16BoldBlack),
            verticalSpace(8),
            ...userNews.map((item) => UserNewsCard(item: item)),
          ],
        ],
      ),
    );
  }
}
