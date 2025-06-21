import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserService {
  static final _firestore = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<void> addXp(int amount) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final docRef = _firestore.collection('users').doc(uid);
    final doc = await docRef.get();

    if (doc.exists) {
      int currentXp = doc['xp'] ?? 0;
      int level = doc['level'] ?? 1;
      int streak = doc['streak'] ?? 0;

      currentXp += amount;

      // logikanya untkNaik level setiap 100 XP(ketika jawabnya bener)
      while (currentXp >= 100) {
        level++;
        currentXp -= 100;
      }

      // streak
      DateTime lastActive = (doc['lastActive'] as Timestamp).toDate();
      DateTime today = DateTime.now();
      Duration diff = today.difference(lastActive);

      if (diff.inDays == 1) {
        streak += 1; 
      } else if (diff.inDays > 1) {
        streak = 1;  
      }

      await docRef.update({
        'xp': currentXp,
        'level': level,
        'streak': streak,
        'lastActive': Timestamp.fromDate(today),
      });
    }
  }
}
