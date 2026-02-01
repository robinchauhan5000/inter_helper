import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/interview_response.dart';
import 'ai_model.dart';
import 'http_client.dart';

/// OpenAI API service for interview assistant
class OpenAIService extends AIModel {
  final HttpClient _httpClient;
  final String apiKey;

  static const String _model = 'gpt-4o-mini';
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

  OpenAIService({required this.apiKey})
      : _httpClient = HttpClient(
          baseUrl: 'https://api.openai.com/v1',
          defaultHeaders: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $apiKey',
          },
          timeout: const Duration(seconds: 60),
        );

  @override
  Future<InterviewResponse> getInterviewResponse(String prompt) async {
    try {
      final response = await _httpClient.post(
        '/chat/completions',
        body: {
          'model': _model,
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'response_format': {'type': 'json_object'},
        },
      );

      if (response.statusCode != 200) {
        throw AIModelException(
          'API request failed with status ${response.statusCode}: ${response.body}',
          provider: 'OpenAI',
        );
      }

      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'] as String;
      final jsonResponse = jsonDecode(content);

      return InterviewResponse.fromJson(jsonResponse);
    } on http.ClientException catch (e) {
      throw AIModelException('Network error: $e', provider: 'OpenAI');
    } on FormatException catch (e) {
      throw AIModelException('Invalid JSON response: $e', provider: 'OpenAI');
    } catch (e) {
      if (e is AIModelException) rethrow;
      throw AIModelException('Unexpected error: $e', provider: 'OpenAI');
    }
  }

  @override
  Future<Stream<String>> streamInterviewResponse(String prompt) async {
    throw UnimplementedError('Streaming not yet implemented');
  }
}
