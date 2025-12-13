import 'package:firebase_database/firebase_database.dart';

class CourseService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<List<Map<String, dynamic>>> getTeacherCourses({required String teacherUid}) async {
    final snapshot = await _db.child("teacher").child(teacherUid).child("courses").get();

    if (!snapshot.exists) {
      return [];
    }

    final Map<dynamic, dynamic> data =
        snapshot.value as Map<dynamic, dynamic>;

    final List<Map<String, dynamic>> courses = [];

    data.forEach((key, value) {
      courses.add({
        "courseUid": key,
        ...Map<String, dynamic>.from(value),
      });
    });

    return courses;

  } 

}  