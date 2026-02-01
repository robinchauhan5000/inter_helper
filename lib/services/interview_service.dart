import '../config/api_config.dart';
import '../models/interview_response.dart';
import 'ai_model.dart';
import 'gemini_service.dart';
import 'openai_service.dart';

/// AI Provider enum
enum AIProvider { openai, gemini }

/// High-level service for interview assistant functionality
class InterviewService {
  late final AIModel _aiModel;
  final AIProvider provider;

  InterviewService({AIProvider? provider, String? apiKey})
    : provider = provider ?? AIProvider.openai {
    switch (this.provider) {
      case AIProvider.openai:
        final key = apiKey ?? ApiConfig.openAiApiKey;
        if (key.isEmpty) {
          throw Exception('OpenAI API key not configured');
        }
        _aiModel = OpenAIService(apiKey: key);
        break;

      case AIProvider.gemini:
        final key = apiKey ?? ApiConfig.geminiApiKey;
        if (key.isEmpty) {
          throw Exception('Gemini API key not configured');
        }
        _aiModel = GeminiService(apiKey: key);
        break;
    }
  }

  /// Get interview response for a given prompt
  Future<InterviewResponse> askQuestion(String prompt) async {
    if (prompt.trim().isEmpty) {
      throw ArgumentError('Prompt cannot be empty');
    }

    return await _aiModel.getInterviewResponse(prompt);
  }

  /// Format response for display
  String formatResponse(InterviewResponse response) {
    final buffer = StringBuffer();
    buffer.writeln('# ${response.title}\n');

    for (final section in response.sections) {
      switch (section.type) {
        case SectionType.shortAnswer:
          buffer.writeln(section.content);
          buffer.writeln();
          break;

        case SectionType.details:
          final details = section.content as List;
          for (final detail in details) {
            buffer.writeln('• $detail');
          }
          buffer.writeln();
          break;

        case SectionType.code:
          buffer.writeln('```${section.language ?? ''}');
          buffer.writeln(section.content);
          buffer.writeln('```');
          buffer.writeln();
          break;
      }
    }

    return buffer.toString();
  }
}
