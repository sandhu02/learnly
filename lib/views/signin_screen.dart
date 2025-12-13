import 'package:flutter/material.dart';
import 'package:learnly/services/auth_service.dart';
import 'package:learnly/views/student/home_screen.dart';
import 'package:learnly/views/register_screen.dart';
import 'package:learnly/views/teacher/teacher_home_screen.dart';


class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  bool isStudent = true; // role toggle
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _auth = AuthService();

  bool _loading = false;

  Future<String?> _login() async {
    setState(() => _loading = true);

    try {
      final user = await _auth.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        selectedRole: isStudent ? "student" : "teacher",
      );
      return user?.uid;

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
      return null; 
    }
    finally {
      if (mounted) {
          setState(() => _loading = false);
        }
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(255, 17, 51, 96),
        title: const Text(
          "Sign In",
          style: TextStyle(color: Colors.white, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 30),
              Icon(
                size: 110,
                Icons.school_rounded,
                color: const Color.fromARGB(255, 17, 51, 96),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            isStudent ? Colors.blueAccent : Colors.grey[300],
                        foregroundColor:
                            isStudent ? Colors.white : Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() => isStudent = true);
                      },
                      child: const Text("Student"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            !isStudent ? Colors.blueAccent : Colors.grey[300],
                        foregroundColor:
                            !isStudent ? Colors.white : Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() => isStudent = false);
                      },
                      child: const Text("Teacher"),
                    ),
                  ),
                ],
              ),
                
              const SizedBox(height: 40),
                
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: "Username",
                  prefixIcon: const Icon(Icons.person),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
                
              const SizedBox(height: 20),
                
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
                
              const SizedBox(height: 30),
                
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 17, 51, 96),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: _loading
                  ? null 
                  : () async {
                      final username = _emailController.text.trim();

                      if (username.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Please enter your username")),
                        );
                        return;
                      }

                      final uid = await _login();  
                      if (uid == null || !mounted) return;

                      if (!mounted) return;

                      if (isStudent) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => HomeScreen(role: isStudent ? "student" : "teacher" , uid: uid),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TeacherHomeScreen(role: isStudent ? "student" : "teacher" , uid: uid),
                          ),
                        );
                      }
                    },

                child: _loading ? CircularProgressIndicator() :
                  const Text(
                    "Sign In",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
              ),
                                
              const SizedBox(height: 30),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to Register screen
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
          
            ],
          ),
        ),
      ),
    );
  }
}
