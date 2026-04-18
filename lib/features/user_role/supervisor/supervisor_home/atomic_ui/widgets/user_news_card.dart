import 'package:flutter/material.dart';
import 'package:hr_management_system_package/supervisor_infrastructure/data/models/supervisor_news_model/user_news_response.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class UserNewsCard extends StatelessWidget {
  const UserNewsCard({super.key, required this.item});

  final UserNewsItem item;

  @override
  Widget build(BuildContext context) {
    final isPublished = item.isPublished ?? false;
    final statusText = isPublished ? 'Published' : 'Draft';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorsManger.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.title ?? '--',
            style: AppStylesManger.font15BoldBlack,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          verticalSpace(8),
          RichText(
            text: TextSpan(
              text: 'Summary: ',
              style: AppStylesManger.font12RegularBlack,
              children: [
                TextSpan(
                  text: item.summary ?? '--',
                  style: AppStylesManger.font12RegularGrey,
                ),
              ],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          verticalSpace(6),
          RichText(
            text: TextSpan(
              text: 'Content: ',
              style: AppStylesManger.font12RegularBlack,
              children: [
                TextSpan(
                  text: item.content ?? '--',
                  style: AppStylesManger.font12RegularGrey,
                ),
              ],
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          verticalSpace(8),
          const Divider(height: 1),
          verticalSpace(8),
          Row(
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    text: 'Published At: ',
                    style: AppStylesManger.font11RegularGrey,
                    children: [
                      TextSpan(
                        text: formatUserNewsDate(item.publishedAt),
                        style: AppStylesManger.font12RegularBlack,
                      ),
                    ],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isPublished
                      ? ColorsManger.doneColor.withValues(alpha: .3)
                      : ColorsManger.grey.withValues(alpha: .2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  statusText,
                  style: AppStylesManger.font11RegularBlack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String formatUserNewsDate(String? date) {
  if (date == null || date.trim().isEmpty) return '--';
  final parsed = DateTime.tryParse(date);
  if (parsed == null) return date;
  return DateFormat('MMM d, yyyy • hh:mm a').format(parsed);
}
