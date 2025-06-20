import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<UserData?> getUserData(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserData.fromMap(doc.data()!);
    } else {
      return null;
    }
  }

  Future<void> updateUserData(String uid, UserData userData) async {
    await _db.collection('users').doc(uid).set(userData.toMap());
  }
}
