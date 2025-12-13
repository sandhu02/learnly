import 'package:flutter/material.dart';
import 'package:learnly/views/student/courses_screen.dart';
import 'package:learnly/views/student/home_tab.dart';
import 'package:learnly/views/student/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final String uid;
  final String role;
  const HomeScreen({super.key, required this.uid , required this.role});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      HomeTab(role: widget.role ,uid: widget.uid), 
      const CoursesScreen(),
      const ProfileScreen(),
    ];
  }
  
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
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ]
      ),
      body: _screens[_selectedIndex],
    );
  }
}