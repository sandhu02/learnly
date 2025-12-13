import 'package:flutter/material.dart';

class TeacherStudentsScreen extends StatefulWidget {
  const TeacherStudentsScreen({super.key});

  @override
  State<TeacherStudentsScreen> createState() => _TeacherStudentsScreenState();
}

class _TeacherStudentsScreenState extends State<TeacherStudentsScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> students = [];
  String selectedCourse = 'All';

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    // Simulated backend data
    // await Future.delayed(const Duration(milliseconds: 500));

    final fetchedStudents = [
      {
        "name": "Ali Raza",
        "course": "Flutter Development",
        "progress": 85,
        "lastSubmission": "2 hours ago",
      },
      {
        "name": "Sara Khan",
        "course": "Python for Data Science",
        "progress": 78,
        "lastSubmission": "4 hours ago",
      },
      {
        "name": "Bilal Ahmed",
        "course": "AI & Machine Learning",
        "progress": 65,
        "lastSubmission": "Yesterday",
      },
      {
        "name": "Hina Tariq",
        "course": "Flutter Development",
        "progress": 92,
        "lastSubmission": "3 days ago",
      },
      {
        "name": "Usman Malik",
        "course": "Python for Data Science",
        "progress": 55,
        "lastSubmission": "5 days ago",
      },
    ];

    setState(() {
      students = fetchedStudents;
      isLoading = false;
    });
  }

  List<String> get allCourses {
    final uniqueCourses = students.map((s) => s['course'] as String).toSet();
    return ['All', ...uniqueCourses];
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
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  const Color.fromARGB(255, 17, 51, 96),
                              child: Text(
                                student['name'][0],
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            title: Text(
                              student['name'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student['course'],
                                  style: const TextStyle(color: Colors.black54),
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: student['progress'] / 100,
                                  backgroundColor: Colors.grey[300],
                                  color: const Color.fromARGB(255, 17, 51, 96),
                                  minHeight: 6,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Progress: ${student['progress']}% | Last submission: ${student['lastSubmission']}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
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
