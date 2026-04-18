import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/supervisor_news_model/supervisor_news_response.dart';

import 'announcement_card.dart';

class AnnouncementListView extends StatelessWidget {
  const AnnouncementListView({
    super.key,
    required this.announcements,
    required this.onRefresh,
  });

  final List<AnnouncementItem> announcements;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: announcements.length,
        itemBuilder: (context, index) {
          return AnnouncementCard(item: announcements[index]);
        },
      ),
    );
  }
}
