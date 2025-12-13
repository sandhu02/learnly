import 'package:flutter/material.dart';
import 'package:learnly/views/signin_screen.dart';

class TeacherProfileScreen extends StatelessWidget {
  const TeacherProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromARGB(255, 17, 51, 96);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // 👤 Profile Avatar
            const CircleAvatar(
              radius: 60,
              child: Icon(
                Icons.person,
                size: 44
              ),
            ),

            const SizedBox(height: 20),

            // 🧑‍🏫 Name
            const Text(
              "Mr. Awais",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 6),
            const Text(
              "Teacher",
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),

            const SizedBox(height: 40),

            // ⚙️ Edit Profile
            ProfileButton(
              icon: Icons.edit,
              label: "Edit Profile",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Edit Profile tapped")),
                );
              },
            ),

            const SizedBox(height: 16),

            // 🔒 Change Password
            ProfileButton(
              icon: Icons.lock_reset,
              label: "Change Password",
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Change Password tapped")),
                );
              },
            ),

            const SizedBox(height: 16),

            // 🚪 Logout
            ProfileButton(
              icon: Icons.logout,
              label: "Logout",
              color: Colors.redAccent,
              onTap: () {
                // Navigate back to SignIn
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SigninScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const ProfileButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = const Color.fromARGB(255, 17, 51, 96),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}
