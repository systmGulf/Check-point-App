import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/helpers/app_spaces.dart';
import '../../../../../../core/styles/colors.dart';
import '../../../../../../core/styles/styles.dart';

class SupervisorUpdatesScreen extends StatelessWidget {
  const SupervisorUpdatesScreen({super.key});

  static const List<_NewsItem> _news = [
    _NewsItem(
      title: 'test',
      summary: 'test',
      content: 'test',
      publishedAt: '2026-04-18T11:00:00',
      isPublished: false,
      id: '019da040-4f80-7e3d-9fab-5ef45dcfda22',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'News',
          style: AppStylesManger.font20SemiBoldBlack,
        ),
        verticalSpace(8),
        ..._news.map((item) => _NewsCard(item: item)),
      ],
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.item});

  final _NewsItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: ColorsManger.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.title, style: AppStylesManger.font16BoldBlack),
          verticalSpace(6),
          Text(
            'Summary: ${item.summary}',
            style: AppStylesManger.font14RegularBlack,
          ),
          verticalSpace(4),
          Text(
            'Content: ${item.content}',
            style: AppStylesManger.font14RegularBlack,
          ),
          verticalSpace(8),
          Text(
            'Published At: ${_formatDate(item.publishedAt)}',
            style: AppStylesManger.font12RegularGrey,
          ),
          verticalSpace(4),
          Text(
            'Status: ${item.isPublished ? 'Published' : 'Draft'}',
            style: AppStylesManger.font12RegularGrey,
          ),
        ],
      ),
    );
  }
}

String _formatDate(String date) {
  final parsed = DateTime.tryParse(date);
  if (parsed == null) return date;
  return DateFormat('MMM d, yyyy • hh:mm a').format(parsed);
}

class _NewsItem {
  final String title;
  final String summary;
  final String content;
  final String publishedAt;
  final bool isPublished;
  final String id;

  const _NewsItem({
    required this.title,
    required this.summary,
    required this.content,
    required this.publishedAt,
    required this.isPublished,
    required this.id,
  });
}
