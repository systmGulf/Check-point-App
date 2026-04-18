import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/supervisor_news_model/company_event_response.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/supervisor_news_model/user_news_response.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/styles.dart';
import 'company_event_card.dart';
import 'user_news_card.dart';

class UserNewsListView extends StatelessWidget {
  const UserNewsListView({
    super.key,
    required this.userNews,
    required this.companyEvents,
    required this.onRefresh,
  });

  final List<UserNewsItem> userNews;
  final List<CompanyEventItem> companyEvents;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    int animationOrder = 0;

    Widget buildAnimatedItem(Widget child) {
      final item = FadeInUp(
        duration: const Duration(milliseconds: 360),
        delay: Duration(milliseconds: animationOrder * 80),
        child: child,
      );
      animationOrder++;
      return item;
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (userNews.isNotEmpty) ...[
            buildAnimatedItem(
              Text(
                'User News (${userNews.length})',
                style: AppStylesManger.font16BoldBlack,
              ),
            ),
            verticalSpace(8),
            ...userNews
                .map((item) => buildAnimatedItem(UserNewsCard(item: item))),
            verticalSpace(10),
          ],
          if (companyEvents.isNotEmpty) ...[
            buildAnimatedItem(
              Text(
                'Company Events (${companyEvents.length})',
                style: AppStylesManger.font16BoldBlack,
              ),
            ),
            verticalSpace(8),
            ...companyEvents
                .map((item) => buildAnimatedItem(CompanyEventCard(item: item))),
          ],
        ],
      ),
    );
  }
}
