import 'package:flutter/material.dart';
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
    // Simulated backend call (you can replace this with API later)
    // await Future.delayed(const Duration(milliseconds: 600));

    final fetchedCourses = [
      {
        "title": "Flutter Development",
        "students": 42,
        "image": "assets/course_icon.jpg",
      },
      {
        "title": "Python for Data Science",
        "students": 36,
        "image": "assets/course_icon.jpg",
      },
      {
        "title": "Machine Learning Essentials",
        "students": 28,
        "image": "assets/course_icon.jpg",
      },
    ];

    setState(() {
      courses = fetchedCourses;
      isLoading = false;
    });
  }

  void _createNewCourse() {
    // You can navigate to a "NewCourseScreen" later
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Create new course tapped")),
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
                          enrolledStudents: course['students'],
                          imagePath: course['image'],
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
                          child: Image.asset(
                            course['image'],
                            height: 90,
                            width: 90,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  course['title'],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "${course['students']} Enrolled Students",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
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
