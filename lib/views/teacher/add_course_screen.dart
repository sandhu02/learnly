import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:learnly/services/auth_service.dart';
import 'package:learnly/services/uploadToCloudinary.dart';
import 'package:learnly/services/user_service.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

  @override
  State<AddCourseScreen> createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final userService = UserService();
  final authService = AuthService();

  bool _loading = false;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController videoController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? selectedVideo;
  File? coverImageFile;

  String? coverImagePath; // later can be set using image picker

  Future<void> uploadAndSaveCourse() async {
    setState(() => _loading = true);
    try {
      String? imageUrl = await uploadToCloudinary(coverImageFile!);
      String? videoUrl = await uploadToCloudinary(selectedVideo!);

      if (imageUrl != null && videoUrl != null) {
        await userService.saveCourseTofirebase(
          teacherUid: authService.currentUser!.uid,
          imageUrl : imageUrl,
          videoUrl : videoUrl,
          title : titleController.text,
          description : descriptionController.text, 
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to upload media to Cloudinary")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
    finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }  
  }

  Future<void> pickVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.gallery);
    
    if (video != null) {
      setState(() {
        selectedVideo = File(video.path);
      });
    }
  }
  Future<void> pickCoverImage() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        coverImageFile = File(image.path);
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Course"),
        backgroundColor: const Color.fromARGB(255, 17, 51, 96),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Cover Image Section
            GestureDetector(
              onTap: pickCoverImage,
              child: Container(
                width: double.infinity,
                height: 200,
                color: Colors.grey.shade300,
                child: coverImageFile == null
                    ? const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 50, color: Colors.grey),
                          SizedBox(height: 8),
                          Text("Tap to add cover image"),
                        ],
                      )
                    : Image.file(
                        coverImageFile!,
                        fit: BoxFit.cover,
                      ),
              ),
            ),

            const SizedBox(height: 16),

            /// Form Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Course Details",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),

                    /// Title
                    TextFormField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: "Course Title",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Title is required" : null,
                    ),
                    const SizedBox(height: 16),

                    /// Description
                    TextFormField(
                      controller: descriptionController,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        labelText: "Course Description",
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) =>
                          value!.isEmpty ? "Description is required" : null,
                    ),
                    const SizedBox(height: 16),

                    /// Video Picker
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Course Video",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 8),

                        GestureDetector(
                          onTap: pickVideo,
                          child: Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade100,
                            ),
                            child: selectedVideo == null
                                ? const Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.video_library,
                                          size: 40, color: Colors.grey),
                                      SizedBox(height: 8),
                                      Text("Tap to select course video"),
                                    ],
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(Icons.check_circle,
                                          color: Colors.green, size: 30),
                                      SizedBox(width: 8),
                                      Text("Video selected"),
                                    ],
                                  ),
                          ),
                        ),

                      ],
                    ),
                    const SizedBox(height: 14),
                    /// Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 17, 51, 96),
                        ),
                        onPressed: () async {
                          if (!_formKey.currentState!.validate() || selectedVideo == null || coverImageFile == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Please fill all fields")),
                            );
                            return; 
                          }
                          try {
                            await uploadAndSaveCourse();

                            // Show success SnackBar
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Course uploaded successfully!"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );

                            // Optional: reset form & clear selected files
                            _formKey.currentState!.reset();
                            setState(() {
                              selectedVideo = null;
                              coverImageFile = null;
                            });

                          } catch (e) {
                            // Show error SnackBar
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Failed to upload course: $e"),
                                backgroundColor: Colors.red,
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          }
                        },
                        child: _loading? CircularProgressIndicator() : 
                          Text(
                            "Add Course",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}