import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnly/services/course_service.dart';
import 'package:learnly/views/teacher/course_detail_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool isLoading = true;
  List<Map<String, dynamic>> courses = [];
  List<Map<String, dynamic>> enrolledCourses = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    fetchAllCourses();
    fetchEnrolledCourses();
  }

  Future<void> fetchAllCourses() async {
    try {
      final fetchedCourses = await CourseService().getAllCourses();
      setState(() {
        courses = fetchedCourses;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load courses: $e")),
      );
    }
  }

  Future <void> enrollInCourse(
    {required String courseUid}
  ) async {
    try {
      await CourseService().enrollInCourse(
        courseUid: courseUid,
        studentUid: FirebaseAuth.instance.currentUser!.uid,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enrolled successfully")),
      );

      // Refresh courses to update enrollment status
      await fetchAllCourses();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to enroll: $e")),
      );
    }
  }

  Future<void> fetchEnrolledCourses() async {
    try {
      final studentUid = FirebaseAuth.instance.currentUser!.uid;
      final fetchedCourses = await CourseService().getEnrolledCourses(
        studentUid: studentUid,
      );

      setState(() {
        enrolledCourses = fetchedCourses;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load enrolled courses: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Courses"),
        backgroundColor: const Color.fromARGB(255, 17, 51, 96),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Enrolled"),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildCourseGrid(courses, isEnrolledTab: false),
                _buildCourseGrid(enrolledCourses, isEnrolledTab: true),
              ],
            ),
    );
  }

  Widget _buildCourseGrid(
    List<Map<String, dynamic>> courses,
    {required bool isEnrolledTab}
  ) {
    if (courses.isEmpty) {
      return const Center(
        child: Text(
          "No courses available",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GridView.builder(
        itemCount: courses.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemBuilder: (context, index) {
          final course = courses[index];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Course Image
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.network(
                    course['imageUrl'],
                    height: 110,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 110,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 40),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course['title'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 6),

                      Text(
                        "Created: ${DateTime.fromMillisecondsSinceEpoch(
                          course['createdAt'],
                        ).toIso8601String().split('T').first}",
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 10),

                      isEnrolledTab
                        ? ElevatedButton(
                            onPressed: () {
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("View Course"),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              try {                                
                                await enrollInCourse(
                                  courseUid: course['courseUid'],
                                );

                                await fetchAllCourses();
                                await fetchEnrolledCourses();
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Failed to enroll: $e")),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 17, 51, 96),
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 36),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Enroll"),
                          ),

                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
