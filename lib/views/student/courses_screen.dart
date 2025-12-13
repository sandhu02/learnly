import 'package:flutter/material.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> allCourses = [
    {
      "title": "Flutter for Beginners",
      "instructor": "John Doe",
      "image": "assets/course_icon.jpg",
      "progress": 0.8,
      "isEnrolled": true
    },
    {
      "title": "Python Fundamentals",
      "instructor": "Sarah Khan",
      "image": "assets/course_icon.jpg",
      "progress": 0.4,
      "isEnrolled": true
    },
    {
      "title": "Machine Learning Basics",
      "instructor": "Ali Ahmed",
      "image": "assets/course_icon.jpg",
      "progress": 0.0,
      "isEnrolled": false
    },
    {
      "title": "UI/UX Design Principles",
      "instructor": "Emily Brown",
      "image": "assets/course_icon.jpg",
      "progress": 0.0,
      "isEnrolled": false
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final enrolledCourses =
        allCourses.where((c) => c['isEnrolled'] == true).toList();
    final recommendedCourses =
        allCourses.where((c) => c['isEnrolled'] == false).toList();

    return Column(
      children: [
        Container(
          color: const Color.fromARGB(255, 17, 51, 96),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.white,
            indicatorWeight: 3,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: const [
              Tab(text: "All"),
              Tab(text: "Enrolled"),
              Tab(text: "Recommended"),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildCourseGrid(allCourses),
              _buildCourseGrid(enrolledCourses),
              _buildCourseGrid(recommendedCourses),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCourseGrid(List<Map<String, dynamic>> courses) {
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
          childAspectRatio: 0.78,
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
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
                  child: Image.asset(
                    course['image'],
                    height: 80,
                    width: double.infinity,
                    fit: BoxFit.cover,
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
                            fontWeight: FontWeight.bold, fontSize: 16),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "By ${course['instructor']}",
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                      const SizedBox(height: 10),
                      if (course['isEnrolled'])
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            LinearProgressIndicator(
                              value: course['progress'],
                              color: const Color.fromARGB(255, 17, 51, 96),
                              backgroundColor: Colors.grey[300],
                              minHeight: 6,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              "Progress: ${(course['progress'] * 100).toInt()}%",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        )
                      else
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 17, 51, 96),
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
