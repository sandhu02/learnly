import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:learnly/services/gemini_api_service.dart';

class MathwayHelpScreen extends StatefulWidget {
  const MathwayHelpScreen({super.key});

  @override
  State<MathwayHelpScreen> createState() => _MathwayHelpScreenState();
}

class _MathwayHelpScreenState extends State<MathwayHelpScreen> {
  File? _image;
  bool isLoading = false;
  String aiResponse = "";

  final ImagePicker _picker = ImagePicker();

  String imageToBase64(File imageFile) {
    final bytes = imageFile.readAsBytesSync();
    return base64Encode(bytes);
  }

  // Open camera to take picture
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _image = file;
      });
      await sendImageToGemini(file);
    }
  }

  // Open gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      setState(() {
        _image = file;
      });
      await sendImageToGemini(file);
    }
  }


  Future<void> sendImageToGemini(File imageFile) async {
    setState(() {
      isLoading = true;
      aiResponse = "";
    });

    try {
      final base64Image = imageToBase64(imageFile);

      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "Solve the math problem shown in the image step by step"
                },
                {
                  "inline_data": {
                    "mime_type": "image/jpeg",
                    "data": base64Image
                  }
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode != 200) {
        throw Exception("Gemini error: ${response.body}");
      }

      final data = jsonDecode(response.body);

      final result =
          data['candidates'][0]['content']['parts'][0]['text'];

      setState(() {
        aiResponse = result;
      });

    } catch (e) {
      setState(() {
        aiResponse = "Error: $e";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Homework Help",
          style: TextStyle(color: Colors.white)
        ),
        backgroundColor: const Color.fromARGB(255, 17, 51, 96),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_image != null)
              Image.file(_image!, height: 200, fit: BoxFit.contain),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImageFromCamera,
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Camera"),
                ),
                ElevatedButton.icon(
                  onPressed: _pickImageFromGallery,
                  icon: const Icon(Icons.photo),
                  label: const Text("Gallery"),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (isLoading)
              const CircularProgressIndicator()
            else if (aiResponse.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        aiResponse,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
