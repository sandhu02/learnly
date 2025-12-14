import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:learnly/services/course_service.dart';
import 'package:learnly/services/user_service.dart';
import 'package:learnly/views/signin_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;

  String userName = "...";
  String userRole = "student";
  String email = "...";
  int? enrolledCourses;
  int? joinedDate;

  Future<void> fetchUserData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final userData = await UserService().getUser(uid:uid , role: userRole);
      
      if (userData != null) {
        setState(() {
          userName = userData['name'] ?? "...";
          email = userData['email'] ?? "...";
          joinedDate = userData['createdAt'];
          enrolledCourses = userData['enrolledCourses'] != null
              ? (userData['enrolledCourses'] as Map).length
              : 0;

          isLoading = false;
        });
      }
    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load user data: $e")),
      );  
    }
  
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 🔹 Profile Header
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    // Avatar
                    const CircleAvatar(
                      radius: 45,
                      child: Icon(
                        Icons.person,
                        size: 44,
                      )
                    ),
                    const SizedBox(width: 20),
                    // User Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            userRole,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: () {
                              // TODO: Navigate to Edit Profile Screen
                            },
                            icon: const Icon(Icons.edit, size: 18),
                            label: const Text("Edit Profile"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 17, 51, 96),
                              foregroundColor: Colors.white,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 User Details
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.email, "Email", email),
                    const Divider(),
                    _buildInfoRow(
                      Icons.calendar_today,
                      "Joined",
                      joinedDate != null
                          ? DateTime.fromMillisecondsSinceEpoch(joinedDate!)
                              .toLocal()
                              .toString()
                              .split(' ')[0]
                          : "N/A",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Statistics Section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem("Enrolled", enrolledCourses?.toString() ?? "0"),
                    _buildStatItem("Completed", "0"),
                    _buildStatItem("Progress", "0%"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Settings / Actions
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildActionTile(Icons.lock, "Change Password", () {}),
                  const Divider(height: 1),
                  _buildActionTile(Icons.swap_horiz, "Switch Role", () {}),
                  const Divider(height: 1),
                  _buildActionTile(
                    Icons.logout,
                    "Logout",
                    () {
                      _showLogoutDialog(context);
                    },
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 17, 51, 96)),
        const SizedBox(width: 12),
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(color: Colors.black87)),
        ),
      ],
    );
  }

  Widget _buildStatItem(String title, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 17, 51, 96),
          ),
        ),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }

  Widget _buildActionTile(IconData icon, String title, VoidCallback onTap,
      {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? const Color.fromARGB(255, 17, 51, 96)),
      title: Text(
        title,
        style: TextStyle(
          color: color ?? Colors.black87,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut(); 

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SigninScreen()),
                  (route) => false,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Logout failed: $e")),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
