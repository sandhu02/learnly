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

  Future<List<Map<String, dynamic>>> getAllEnrolledStudentsForTeacher({
    required String teacherUid,
  }) async {
    final DatabaseReference db = FirebaseDatabase.instance.ref();

    // 1️⃣ Get teacher courses
    final coursesSnap =
        await db.child('teacher').child(teacherUid).child('courses').get();

    if (!coursesSnap.exists) return [];

    final Map<dynamic, dynamic> courses =
        coursesSnap.value as Map<dynamic, dynamic>;

    // 2️⃣ Collect unique student UIDs
    final Set<String> studentUids = {};

    for (final courseEntry in courses.entries) {
      final enrolledStudents = courseEntry.value['enrolledStudents'];
      if (enrolledStudents != null) {
        final Map<dynamic, dynamic> studentsMap =
            enrolledStudents as Map<dynamic, dynamic>;

        studentUids.addAll(
          studentsMap.keys.map((e) => e.toString()),
        );
      }
    }

    if (studentUids.isEmpty) return [];

    // 3️⃣ Fetch student profiles in parallel
    final futures = studentUids.map((uid) async {
      final snap = await db.child('student').child(uid).get();
      if (!snap.exists) return null;

      final data = Map<String, dynamic>.from(
        snap.value as Map<dynamic, dynamic>,
      );

      data['uid'] = uid; // attach uid
      return data;
    });

    // 4️⃣ Resolve futures and remove nulls
    final students = (await Future.wait(futures))
        .whereType<Map<String, dynamic>>()
        .toList();

    return students;
  }

  Future <Map<String, dynamic>?> getCourseDetails({
    required String courseUid,
  }) async {
    final snapshot = await _db.child("courses").child(courseUid).get();

    if (!snapshot.exists || snapshot.value == null) {
      return null;
    }

    final Map<dynamic, dynamic> rawData =
        snapshot.value as Map<dynamic, dynamic>;

    // Convert to Map<String, dynamic>
    final Map<String, dynamic> data =
        Map<String, dynamic>.from(rawData);

    return data;
  }
}  

