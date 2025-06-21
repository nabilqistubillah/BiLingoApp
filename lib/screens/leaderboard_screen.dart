import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  Future<List<Map<String, dynamic>>> fetchTopUsers() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .orderBy('xp', descending: true)
        .limit(10)
        .get();

    return querySnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'id': doc.id,
        'xp': data['xp'] ?? 0,
        'level': data['level'] ?? 1,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🏆 Leaderboard')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchTopUsers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada pengguna di leaderboard.'));
          }

          final users = snapshot.data!;
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text('#${index + 1}'),
                ),
                title: Text('User ID: ${user['id']}'),
                subtitle: Text('XP: ${user['xp']} | Level: ${user['level']}'),
              );
            },
          );
        },
      ),
    );
  }
}
