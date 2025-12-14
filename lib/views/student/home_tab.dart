import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnly/services/course_service.dart';
import 'package:learnly/services/user_service.dart';
import 'package:learnly/views/student/ai_camera_screen.dart';
import 'package:learnly/views/student/ai_chat_screen.dart';

class HomeTab extends StatefulWidget {
  final String uid;
  final String role;
  const HomeTab({super.key, required this.uid, required this.role});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final userService = UserService();
  String userName = "...";

  List<Map<String, dynamic>> featuredCourses = [];
  List<Map<String, dynamic>> continueCourses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData(); // Simulate backend call
    fetchName();
  }

  Future<void> fetchName() async {
    final name = await userService.getUserName(uid: widget.uid, role: widget.role);
    if (mounted) {
      setState(() {
        userName = name ?? "Student";
      });
    }
  }

  Future<void> fetchData() async {
    try {
      final studentUid = FirebaseAuth.instance.currentUser!.uid;
      final fetchedCourses = await CourseService().getEnrolledCourses(
        studentUid: studentUid,
      );

      setState(() {
        featuredCourses = fetchedCourses;
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
            "Continue your learning journey.",
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 20),

          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: "Search for courses...",
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

          // Featured Courses
          const Text(
            "Featured Courses",
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
              itemCount: featuredCourses.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final course = featuredCourses[index];
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
                        child: Image.network(
                          course['imageUrl'] as String,
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
                              "Enrolled on : ${DateTime.fromMillisecondsSinceEpoch((course['enrolledAt'] ?? 0) as int).toLocal().toString().split(' ')[0]}",
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

          // Continue Learning
          const Text(
            "Continue Learning",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 17, 51, 96),
            ),
          ),
          const SizedBox(height: 12),

          // Chat / Study with AI Tile
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.blue.shade50,
            child: ListTile(
              leading: const Icon(
                Icons.smart_toy,
                color: Color.fromARGB(255, 17, 51, 96),
                size: 40,
              ),
              title: const Text(
                "Study with AI",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Chat with our AI assistant to learn or get help with your courses.",
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to AI chat screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AIChatScreen()),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Image Homework Help Tile
          Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.green.shade50,
            child: ListTile(
              leading: const Icon(
                Icons.image_search,
                color: Color.fromARGB(255, 17, 51, 96),
                size: 40,
              ),
              title: const Text(
                "Homework Help",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Take an image of your homework problem and get step-by-step solutions.",
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Navigate to Mathway/Image Homework Help screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MathwayHelpScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
