import 'package:flutter/material.dart';
import 'package:learnly/views/teacher/teacher_courses_screen.dart';
import 'package:learnly/views/teacher/teacher_home_tab.dart';
import 'package:learnly/views/teacher/teacher_profile_screen.dart';
import 'package:learnly/views/teacher/teacher_students_screen.dart';

class TeacherHomeScreen extends StatefulWidget {
  final String uid;
  const TeacherHomeScreen({super.key, required this.uid});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      TeacherHomeTab(uid: widget.uid),
      const Center(child: TeacherCoursesScreen()),
      const Center(child: TeacherStudentsScreen()),
      const Center(child: TeacherProfileScreen()),
    ];
    
  }
  // list of screens (tabs)

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 17, 51, 96),
        title: Text(
          style: TextStyle(
            color: Colors.white,
            fontSize: 30
          ),
          "Learnly"
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            color: Colors.white,
            iconSize: 28,
            tooltip: "Notifications",
            onPressed: () {
              // handle notification click
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No new notifications")),
              );
            },
          ),
          const SizedBox(width: 10)
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 17, 51, 96),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_2),
            label: 'Students',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ]
      ),
      body: _screens[_selectedIndex],
    );
  }
}