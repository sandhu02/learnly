import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnly/services/course_service.dart';

class TeacherStudentsScreen extends StatefulWidget {
  const TeacherStudentsScreen({super.key});

  @override
  State<TeacherStudentsScreen> createState() => _TeacherStudentsScreenState();
}

class _TeacherStudentsScreenState extends State<TeacherStudentsScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> students = [];
  List<Map<String, dynamic>> courses = [];
  Map<String, String> courseNames = {};

  String selectedCourse = 'All';

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    try {
      setState(() => isLoading = true);

      final teacherId = FirebaseAuth.instance.currentUser!.uid;
      final fetchedStudents =
          await CourseService().getAllEnrolledStudentsForTeacher(teacherUid: teacherId);

      if (fetchedStudents.isEmpty) {
        setState(() => isLoading = false);
        return;
      }

      // Collect all courseIds from students
      final courseIds = <String>{};
      for (final student in fetchedStudents) {
        final enrolled = student['enrolledCourses'] as Map<dynamic, dynamic>?;
        if (enrolled != null) {
          courseIds.addAll(enrolled.keys.map((e) => e.toString()));
        }
      }

      // Fetch all course details in parallel
      final futures = courseIds.map((id) async {
        final course = await CourseService().getCourseDetails(courseUid: id);
        return {id: course?['title'] ?? 'N/A'};
      });

      final results = await Future.wait(futures);

      // Combine results into courseNames map
      courseNames = {for (var r in results) ...r};

      setState(() {
        students = fetchedStudents;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to load students: $e')));
    }
  }

  List<String> get allCourses {
    final courseSet = <String>{};

    for (final student in students) {
      final enrolled = student['enrolledCourses'] as Map<dynamic, dynamic>?;
      if (enrolled != null) {
        courseSet.addAll(enrolled.keys.map((k) => k.toString()));
      }
    }

    return ['All', ...courseSet];
  }


  @override
  Widget build(BuildContext context) {
    final filteredStudents = selectedCourse == 'All'
        ? students
        : students.where((s) => s['course'] == selectedCourse).toList();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // 🔍 Filter Dropdown
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Filter by Course:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 17, 51, 96),
                        ),
                      ),
                      DropdownButton<String>(
                        value: selectedCourse,
                        items: allCourses.map((course) {
                          return DropdownMenuItem<String>(
                            value: course,
                            child: Text(course),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedCourse = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Student List
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];

                        final studentName = student['name'] ?? 'Unknown';
                        final studentEmail = student['email'] ?? 'Unknown';

                        final enrolledCourses = student['enrolledCourses'] as Map<dynamic, dynamic>?;

                        String courseName = 'N/A';
                        String enrolledAtStr = 'N/A';

                        if (enrolledCourses != null && enrolledCourses.isNotEmpty) {
                          // Pick the first course for display
                          final firstCourseId = enrolledCourses.keys.first.toString();
                          final courseData = enrolledCourses[firstCourseId] as Map<dynamic, dynamic>?;

                          courseName = courseNames[firstCourseId] ?? 'N/A';
                          if (courseData != null && courseData['enrolledAt'] != null) {
                            final enrolledAt = courseData['enrolledAt'] as int;
                            enrolledAtStr =
                                DateTime.fromMillisecondsSinceEpoch(enrolledAt).toLocal().toString().split(' ')[0];
                          }
                        }

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: const Color.fromARGB(255, 17, 51, 96),
                              child: Text(
                                studentName[0], // first letter of name
                                style: const TextStyle(color: Colors.white, fontSize: 18),
                              ),
                            ),
                            title: Text(
                              studentName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            trailing: Text(
                              "Enrolled on: $enrolledAtStr"
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  courseName,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  studentEmail,
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 4),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
