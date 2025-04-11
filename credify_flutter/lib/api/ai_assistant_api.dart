// lib/api/ai_assistant_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AIAssistantApi {
  final String baseUrl;
  final String apiKey;

  AIAssistantApi({
    required this.baseUrl,
    required this.apiKey,
  });

  Future<String> askQuestion(String userId, String question) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/assistant/ask'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          'userId': userId,
          'question': question,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['answer'] as String;
      } else {
        throw Exception('Failed to get answer: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error contacting AI assistant: $e');
    }
  }

  Future<Map<String, dynamic>> getSpendingAnalysis(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/assistant/analysis/$userId'),
        headers: {
          'Authorization': 'Bearer $apiKey',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to get analysis: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting spending analysis: $e');
    }
  }
}