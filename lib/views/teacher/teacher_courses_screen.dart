import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:learnly/services/course_service.dart';
import 'package:learnly/views/teacher/add_course_screen.dart';
import 'package:learnly/views/teacher/course_detail_screen.dart';

class TeacherCoursesScreen extends StatefulWidget {
  const TeacherCoursesScreen({super.key});

  @override
  State<TeacherCoursesScreen> createState() => _TeacherCoursesScreenState();
}

class _TeacherCoursesScreenState extends State<TeacherCoursesScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> courses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  Future<void> fetchCourses() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Get the current signed-in teacher UID
      final teacherUid = FirebaseAuth.instance.currentUser!.uid;

      // Fetch courses from your CourseService
      final fetchedCourses = await CourseService().getTeacherCourses(
        teacherUid: teacherUid,
      );

      setState(() {
        courses = fetchedCourses;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load courses: $e')),
      );
    }
  }

  void _createNewCourse() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddCourseScreen()
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CourseDetailScreen(
                            courseTitle: course['title'],
                            enrolledStudents: course['enrolled'] ?? 0,
                            imageUrl: course['imageUrl'] ?? '', 
                            description: course['description'], 
                            videoUrl: course['videoUrl'], 
                            createdAt: course['createdAt'], // network URL
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                bottomLeft: Radius.circular(12)),
                            child: course['imageUrl'] != null
                                ? Image.network(
                                    course['imageUrl'],
                                    height: 90,
                                    width: 90,
                                    fit: BoxFit.cover,
                                  )
                                : Container(
                                    height: 90,
                                    width: 90,
                                    color: Colors.grey.shade300,
                                    child: const Icon(Icons.image, color: Colors.grey),
                                  ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course['title'] ?? "No Title",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    course['description'] ?? "No Description",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Created on: ${DateFormat('yyyy-MM-dd').format(
                                      DateTime.fromMillisecondsSinceEpoch(course['createdAt'] ?? 0).toLocal()
                                    )}",
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 17, 51, 96),
        onPressed: _createNewCourse,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

}
