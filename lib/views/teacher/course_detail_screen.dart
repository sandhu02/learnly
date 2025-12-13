import 'package:flutter/material.dart';

class CourseDetailScreen extends StatelessWidget {
  final String courseTitle;
  final int enrolledStudents;
  final String imagePath;

  const CourseDetailScreen({
    super.key,
    required this.courseTitle,
    required this.enrolledStudents,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(courseTitle),
        backgroundColor: const Color.fromARGB(255, 17, 51, 96),
        foregroundColor: Colors.white,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, width: double.infinity, height: 200, fit: BoxFit.cover),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "$enrolledStudents students enrolled",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Course Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
