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


  Future<List<Map<String, dynamic>>> getAllCourses() async {
    final snapshot = await _db.child("teacher").get();

    if (!snapshot.exists) {
      return [];
    }

    final Map<dynamic, dynamic> teachers =
        snapshot.value as Map<dynamic, dynamic>;

    final List<Map<String, dynamic>> allCourses = [];

    teachers.forEach((teacherUid, teacherData) {
      if (teacherData["courses"] != null) {
        final Map<dynamic, dynamic> courses =
            teacherData["courses"] as Map<dynamic, dynamic>;

        courses.forEach((courseUid, courseData) {
          allCourses.add({
            "courseUid": courseUid,
            "teacherUid": teacherUid,
            ...Map<String, dynamic>.from(courseData),
          });
        });
      }
    });

    return allCourses;
  }

  Future<void> enrollInCourse({
    required String studentUid,
    required String courseUid,
  }) async {
    try {
      final teacherSnap = await _db
          .child("courses")
          .child(courseUid)
          .child("teacherUid")
          .get();

      if (!teacherSnap.exists || teacherSnap.value == null) {
        throw Exception("Teacher UID not found for course $courseUid");
      }

      final String teacherUid = teacherSnap.value.toString();
            
      final int timestamp = DateTime.now().millisecondsSinceEpoch;
      
      final DatabaseReference studentCourseRef =
          _db.child("student").child(studentUid).child("enrolledCourses").child(courseUid);
      
      final DatabaseReference teacherCourseStudentRef =
          _db.child("teacher").child(teacherUid).child("courses").child(courseUid)
              .child("enrolledStudents").child(studentUid);
      
      final DatabaseReference courseStudentRef =
          _db.child("courses").child(courseUid).child("enrolledStudents").child(studentUid);
      
      await Future.wait([
        studentCourseRef.set({
          "teacherUid": teacherUid,
          "enrolledAt": timestamp,
        }),
      
        teacherCourseStudentRef.set({
          "enrolledAt": timestamp,
        }),
      
        courseStudentRef.set({
          "enrolledAt": timestamp,
        }),
      ]);
    } catch (e) {
      print("Enrollment failed: $e");
      throw Exception("Enrollment failed: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getEnrolledCourses({
    required String studentUid,
  }) async {
    final DatabaseReference studentCoursesRef =
        _db.child("student").child(studentUid).child("enrolledCourses");

    final snapshot = await studentCoursesRef.get();

    if (!snapshot.exists) {
      return [];
    }

    final Map<dynamic, dynamic> enrolledCourses =
        snapshot.value as Map<dynamic, dynamic>;

    final List<Map<String, dynamic>> courses = [];

    for (final entry in enrolledCourses.entries) {
      final String courseUid = entry.key;
      final Map data = entry.value;

      final courseSnapshot =
          await _db.child("courses").child(courseUid).get();

      if (courseSnapshot.exists) {
        courses.add({
          "courseUid": courseUid,
          "teacherUid": data["teacherUid"],
          "enrolledAt": data["enrolledAt"],
          "isEnrolled": true,
          ...Map<String, dynamic>.from(courseSnapshot.value as Map),
        });
      }
    }

    return courses;
  }

}  