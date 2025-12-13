import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';

class UserService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref("users");

  /// Get user once
  Future<AppUser?> getUser(String uid) async {
    final snapshot = await _db.child(uid).get();

    if (!snapshot.exists) return null;

    final data = snapshot.value as Map<dynamic, dynamic>;
    return AppUser.fromMap(uid, data);
  }

  /// Listen to user changes (real-time)
  Stream<AppUser?> streamUser(String uid) {
    return _db.child(uid).onValue.map((event) {
      if (!event.snapshot.exists) return null;

      final data =
          event.snapshot.value as Map<dynamic, dynamic>;
      return AppUser.fromMap(uid, data);
    });
  }
  
  /// Get user name
  Future<String?> getUserName(String uid) async {
  final snapshot = await _db.child(uid).child("name").get();

  if (!snapshot.exists) return null;

  return snapshot.value as String;
}

  /// Update name
  Future<void> updateName(String uid, String name) async {
    await _db.child(uid).update({
      "name": name,
    });
  }
}
