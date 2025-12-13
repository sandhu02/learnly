import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String?> uploadToCloudinary(File file) async {
  const cloudName = "dbjytesyl";
  const uploadPreset = "learnly_course_upload";

  final url = Uri.parse(
    "https://api.cloudinary.com/v1_1/$cloudName/auto/upload",
  );

  final request = http.MultipartRequest("POST", url);

  request.fields['upload_preset'] = uploadPreset;
  request.files.add(
    await http.MultipartFile.fromPath("file", file.path),
  );

  final response = await request.send();
  final responseBody = await response.stream.bytesToString();

  if (response.statusCode == 200) {
    final data = jsonDecode(responseBody);
    return data['secure_url']; // ✅ final URL
  } else {
    return null;
  }
}
