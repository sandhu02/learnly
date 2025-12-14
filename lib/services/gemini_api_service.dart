import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiApiService {
  final String apiKey; // WARNING: Do NOT commit this to public repos
  final String projectId;
  final String location;

  GeminiApiService({
    required this.apiKey,
    required this.projectId,
    this.location = "us-central1",
  });

  Future<String> sendMessage(String prompt) async {
    final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey');

    final body = {
      "contents": [
        {
          "parts": [
            { "text": prompt }
          ]
        }
      ],
      // "generationConfig": {
      //   "temperature": 0.7,
      //   "topK": 40,
      //   "topP": 0.95,
      // }
    };


    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final String aiText =
        data['candidates']?[0]?['content']?['parts']?[0]?['text'] ??
        "No response from AI";

      return aiText;
    } else {
      throw Exception(
          "Failed to call Gemini API: ${response.statusCode} ${response.body}");
    }
  }
}

final aiService = GeminiApiService(
  apiKey: apiKey, // 👈 risky in frontend
  projectId: "1086926094630",
);


final apiKey = "AIzaSyCVnxRBJgy2kOVowQhTNHpjN3TwNIO0Q7s";