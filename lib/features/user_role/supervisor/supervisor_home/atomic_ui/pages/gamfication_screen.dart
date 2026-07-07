import 'package:employee_mangement/core/styles/colors.dart';
import 'package:flutter/material.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // قائمة بيانات المستخدمين
    final List<Map<String, dynamic>> users = [
      {
        'rank': 1,
        'name': 'Arthur Andrews',
        'score': 13,
        'achievements': 14,
        'isTopUser': true
      },
      {'rank': 2, 'name': 'osama mahmoud', 'score': 11, 'achievements': 13},
      {'rank': 3, 'name': 'Kamel Adel', 'score': 8, 'achievements': 1},
      {'rank': 4, 'name': 'Radwa Alaa', 'score': 8, 'achievements': 2},
      {'rank': 5, 'name': 'Aya tamer', 'score': 3, 'achievements': 3},
    ];

    return Scaffold(
      appBar: AppBar(
          backgroundColor: ColorsManger.primaryColor,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          )),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // قسم المستخدم الأول (الشخص صاحب المرتبة الأولى)
            _buildTopUserSection(users.firstWhere((user) => user['isTopUser'])),
            const SizedBox(height: 20),
            // قسم إنجازات المستخدم الأول
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emoji_events, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  '${users.firstWhere((user) => user['isTopUser'])['achievements']}/17 Achievements',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // قائمة المستخدمين
            _buildUserList(users.sublist(1)),
          ],
        ),
      ),
    );
  }

  // --- دوال بناء الأجزاء ---

  Widget _buildTopUserSection(Map<String, dynamic> user) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // الشريط الذهبي
        Container(
          height: 200,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [ColorsManger.primaryColor, ColorsManger.lightblack],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // الأيقونة الرئيسية
        const Positioned(
          top: 40,
          child: Icon(
            Icons.account_circle,
            size: 100,
            color: Colors.white,
          ),
        ),
        // الشريط الذي يحمل Score و Rank
        Positioned(
          top: 100,
          child: Container(
            width: 300,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildScoreRankItem(
                    label: 'Score', value: user['score'].toString()),
                _buildScoreRankItem(
                    label: 'Rank', value: user['rank'].toString()),
              ],
            ),
          ),
        ),
        // أيقونة الكأس
        const Positioned(
          top: 150,
          child: Icon(Icons.emoji_events, size: 50, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildScoreRankItem({required String label, required String value}) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 16),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildUserList(List<Map<String, dynamic>> users) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return _buildUserListItem(
          rank: user['rank'],
          name: user['name'],
          score: user['score'],
          achievements: user['achievements'],
        );
      },
    );
  }

  Widget _buildUserListItem({
    required int rank,
    required String name,
    required int score,
    required int achievements,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: _getRankColor(rank),
            child: Text(
              rank.toString(),
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  score.toString(),
                  style: const TextStyle(color: Colors.orange),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Icon(Icons.emoji_events_outlined, color: Colors.grey),
              Text(
                '$achievements/17',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.blueGrey;
      case 3:
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }
}
