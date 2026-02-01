import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/interview_response.dart';
import 'ai_model.dart';
import 'http_client.dart';

/// Gemini AI API service for interview assistant
class GeminiService extends AIModel {
  final HttpClient _httpClient;
  final String apiKey;

  static const String _model = 'gemini-3-flash-preview';
  static const String _systemPrompt = '''
You are an Interview Assistant.

STRICT RULES:
1. Respond in VALID JSON only.
2. Follow the response schema exactly.
3. Do NOT include markdown outside JSON.
4. Do NOT add extra fields.
5. Keep answers concise and interview-focused.
6. Sections must appear in a logical order.

RESPONSE SCHEMA:
{
  "title": "string",
  "sections": [
    {
      "type": "short_answer",
      "content": "string"
    },
    {
      "type": "details",
      "content": ["string"]
    },
    {
      "type": "code",
      "language": "string",
      "content": "string"
    }
  ]
}

ALLOWED SECTION TYPES:
- short_answer
- details
- code

If a section is not relevant, omit it.
''';

  GeminiService({required this.apiKey})
    : _httpClient = HttpClient(
        baseUrl: 'https://generativelanguage.googleapis.com/v1beta',
        defaultHeaders: {
          'Content-Type': 'application/json',
          'x-goog-api-key': apiKey,
        },
        timeout: const Duration(seconds: 60),
      );

  @override
  Future<InterviewResponse> getInterviewResponse(String prompt) async {
    try {
      final response = await _httpClient.post(
        '/models/$_model:generateContent',
        body: {
          'contents': [
            {
              'parts': [
                {'text': '$_systemPrompt\n\nUser Question: $prompt'},
              ],
            },
          ],
          'generationConfig': {
            'temperature': 0.7,
            'responseMimeType': 'application/json',
          },
        },
      );

      if (response.statusCode != 200) {
        throw AIModelException(
          'API request failed with status ${response.statusCode}: ${response.body}',
          provider: 'Gemini',
        );
      }

      final data = jsonDecode(response.body);

      // Extract text from Gemini response structure
      final candidates = data['candidates'] as List?;
      if (candidates == null || candidates.isEmpty) {
        throw AIModelException(
          'No response candidates returned',
          provider: 'Gemini',
        );
      }

      final content = candidates[0]['content'];
      final parts = content['parts'] as List;
      if (parts.isEmpty) {
        throw AIModelException(
          'No content parts in response',
          provider: 'Gemini',
        );
      }

      final textContent = parts[0]['text'] as String;
      final jsonResponse = jsonDecode(textContent);

      return InterviewResponse.fromJson(jsonResponse);
    } on http.ClientException catch (e) {
      throw AIModelException('Network error: $e', provider: 'Gemini');
    } on FormatException catch (e) {
      throw AIModelException('Invalid JSON response: $e', provider: 'Gemini');
    } catch (e) {
      if (e is AIModelException) rethrow;
      throw AIModelException('Unexpected error: $e', provider: 'Gemini');
    }
  }

  @override
  Future<Stream<String>> streamInterviewResponse(String prompt) async {
    throw UnimplementedError('Streaming not yet implemented');
  }
}
