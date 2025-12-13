import 'package:flutter/material.dart';
import 'package:learnly/services/user_service.dart';

class TeacherHomeTab extends StatefulWidget {
  final String uid;
  const TeacherHomeTab({super.key, required this.uid});

  @override
  State<TeacherHomeTab> createState() => _TeacherHomeTabState();
}

class _TeacherHomeTabState extends State<TeacherHomeTab> {
  final userService = UserService();
  List<Map<String, dynamic>> yourCourses = [];
  List<Map<String, dynamic>> recentSubmissions = [];
  bool isLoading = true;
  String userName = "...";

  @override
  void initState() {
    super.initState();
    fetchTeacherData();
    fetchName();
  }

  Future<void> fetchName() async {
    final name = await userService.getUserName(widget.uid);
    if (mounted) {
      setState(() {
        userName = name ?? "Student";
      });
    }
  }

  Future<void> fetchTeacherData() async {
    // Simulated backend data (no delay)
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
        "title": "AI & Machine Learning",
        "students": 28,
        "image": "assets/course_icon.jpg",
      },
    ];

    final fetchedSubmissions = [
      {
        "student": "Ali Raza",
        "course": "Flutter Development",
        "time": "2 hours ago",
      },
      {
        "student": "Sara Khan",
        "course": "Python for Data Science",
        "time": "4 hours ago",
      },
      {
        "student": "Bilal Ahmed",
        "course": "AI & Machine Learning",
        "time": "Yesterday",
      },
    ];

    setState(() {
      yourCourses = fetchedCourses;
      recentSubmissions = fetchedSubmissions;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            "Welcome $userName",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 17, 51, 96),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            "Manage your courses and students easily.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: "Search students or courses...",
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Your Courses Section
          const Text(
            "Your Courses",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 17, 51, 96),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: yourCourses.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final course = yourCourses[index];
                return Container(
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius:
                            const BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.asset(
                          course['image'] as String,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course['title'] as String,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${course['students']} Students",
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          // Recent Submissions
          const Text(
            "Recent Submissions",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 17, 51, 96),
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: recentSubmissions.map((submission) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: const Icon(Icons.assignment_turned_in,
                      color: Color.fromARGB(255, 17, 51, 96), size: 32),
                  title: Text(submission['student'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(
                    "Submitted for ${submission['course']}",
                    style: const TextStyle(fontSize: 13),
                  ),
                  trailing: Text(
                    submission['time'] as String,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Announcements / News
          const Text(
            "Announcements",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 17, 51, 96),
            ),
          ),
          const SizedBox(height: 10),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 2,
            child: const ListTile(
              leading: Icon(Icons.campaign,
                  color: Color.fromARGB(255, 17, 51, 96)),
              title: Text(
                "Midterm Schedule Released",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Midterms will start from next week. Please upload question papers on time.",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
