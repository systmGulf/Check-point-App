import 'package:employee_mangement/core/common/app_container_decoration.dart';
import 'package:employee_mangement/core/helpers/app_spaces.dart';
import 'package:employee_mangement/core/styles/colors.dart';
import 'package:employee_mangement/core/widgets/build_custom_app_bar.dart';
import 'package:flutter/material.dart';

import '../atoms/client_info_tile.dart';

class ClientDetailsScreen extends StatelessWidget {
  const ClientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: buildCustomAppBar(context, 'Client Details'),
        body: Column(
          children: [
            verticalSpace(16),
            Column(
              children: const [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/300',
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Jenny Wilson',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Software Engineer',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TabBar(
              labelColor: ColorsManger.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: ColorsManger.primaryColor,
              tabs: [
                Tab(text: 'Details'),
                Tab(text: 'Visits'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _DetailsTab(),
                  ClientVisitsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ClientInfoTile(
          icon: Icons.cake,
          title: '16th Aug, 1981',
        ),
        ClientInfoTile(
          icon: Icons.language,
          title: 'English, Spanish',
        ),
        ClientInfoTile(
          icon: Icons.location_on,
          title: '3891 Ranchview Dr, Richardson, California',
        ),
        ClientInfoTile(
          icon: Icons.phone,
          title: '+20 01150721902',
        ),
      ],
    );
  }
}

class ClientVisitsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        ClientVisitCard(
          date: 'Wednesday, 14th Aug 2024',
          time: '09:30 AM - 7:30 PM',
        ),
      ],
    );
  }
}

class ClientVisitCard extends StatelessWidget {
  final String date;
  final String time;

  const ClientVisitCard({required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: AppContainerDecoration(),
      child: ListTile(
        leading: Icon(Icons.calendar_today, color: ColorsManger.primaryColor),
        title: Text(date),
        subtitle: Text(time),
      ),
    );
  }
}
