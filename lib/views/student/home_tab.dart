import 'package:flutter/material.dart';
import 'package:learnly/services/user_service.dart';

class HomeTab extends StatefulWidget {
  final String uid;
  const HomeTab({super.key, required this.uid});

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
    final name = await userService.getUserName(widget.uid);
    if (mounted) {
      setState(() {
        userName = name ?? "Student";
      });
    }
  }

  Future<void> fetchData() async {

    // Simulated backend data
    final fetchedFeaturedCourses = [
      {
        "title": "Flutter for Beginners",
        "instructor": "John Doe",
        "image": "assets/course_icon.jpg",
      },
      {
        "title": "Python Fundamentals",
        "instructor": "Sarah Khan",
        "image": "assets/course_icon.jpg",
      },
      {
        "title": "Machine Learning Basics",
        "instructor": "Ali Ahmed",
        "image": "assets/course_icon.jpg",
      },
    ];

    final fetchedContinueCourses = [
      {
        "title": "Flutter for Beginners",
        "progress": 0.8,
        "image": "assets/course_icon.jpg",
      },
      {
        "title": "Python Fundamentals",
        "progress": 0.4,
        "image": "assets/course_icon.jpg",
      },
    ];

    setState(() {
      featuredCourses = fetchedFeaturedCourses;
      continueCourses = fetchedContinueCourses;
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
                              "By ${course['instructor']}",
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
          Column(
            children: continueCourses.map((course) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      course['image'] as String,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(course['title'] as String,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      LinearProgressIndicator(
                        value: course['progress'] as double,
                        color: const Color.fromARGB(255, 17, 51, 96),
                        backgroundColor: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                        minHeight: 6,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Progress: ${( (course['progress'] as double) * 100).toInt()}%",
                        style:
                            const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
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
            child: ListTile(
              leading: const Icon(Icons.campaign,
                  color: Color.fromARGB(255, 17, 51, 96)),
              title: const Text(
                "New AI Course Released!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                "Learn about the fundamentals of Artificial Intelligence with our latest course.",
              ),
            ),
          ),
        ],
      ),
    );
  }
}
