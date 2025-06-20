class UserData {
  final int xp;
  final int level;
  final int streak;
  final DateTime lastActive;

  UserData({
    required this.xp,
    required this.level,
    required this.streak,
    required this.lastActive,
  });

  factory UserData.fromMap(Map<String, dynamic> data) {
    return UserData(
      xp: data['xp'] ?? 0,
      level: data['level'] ?? 1,
      streak: data['streak'] ?? 0,
      lastActive: DateTime.parse(data['lastActive']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'xp': xp,
      'level': level,
      'streak': streak,
      'lastActive': lastActive.toIso8601String(),
    };
  }
}
