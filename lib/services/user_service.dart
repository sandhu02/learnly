import 'package:firebase_database/firebase_database.dart';
import '../models/user_model.dart';

class UserService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

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

      final data = event.snapshot.value as Map<dynamic, dynamic>;
      return AppUser.fromMap(uid, data);
    });
  }
  
  /// Get user name
  Future<String?> getUserName({required String uid, required String role}) async {
    final snapshot = await _db.child(role).child(uid).child("name").get();

    if (!snapshot.exists) return null;

    return snapshot.value as String;
  }

  /// Update name
  Future<void> updateName(String uid, String name) async {
    await _db.child(uid).update({
      "name": name,
    });
  }

  /// Save image/video url to firebase database
  Future<void> saveCourseTofirebase(
    {
      required String teacherUid,
      required String title, 
      required String description, 
      required String imageUrl, 
      required String videoUrl, 
    }
  ) async {
    final DatabaseReference courseRef =
      _db.child("teacher").child(teacherUid).child("courses").push();

      final String courseUid = courseRef.key!;  

      await courseRef.set({
        "courseUid": courseUid,
        "title": title,
        "description": description,
        "imageUrl": imageUrl,
        "videoUrl": videoUrl,
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      });

  } 
}
