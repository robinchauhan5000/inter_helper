import '../services/interview_service.dart';
import '../models/interview_response.dart';

/// Example usage of the Interview Service
class InterviewServiceExample {
  /// Example 1: Basic usage
  static Future<void> basicExample() async {
    // Initialize service with API key
    final service = InterviewService(apiKey: 'your-openai-api-key-here');

    try {
      // Ask a question
      final response = await service.askQuestion(
        'Explain what is a closure in JavaScript',
      );

      // Print formatted response
      print(service.formatResponse(response));

      // Access structured data
      print('Title: ${response.title}');
      for (final section in response.sections) {
        print('Section type: ${section.type.value}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 2: Handle different section types
  static Future<void> handleSectionsExample() async {
    final service = InterviewService(apiKey: 'your-openai-api-key-here');

    try {
      final response = await service.askQuestion(
        'How do I implement a binary search in Python?',
      );

      for (final section in response.sections) {
        switch (section.type) {
          case SectionType.shortAnswer:
            print('Answer: ${section.content}');
            break;

          case SectionType.details:
            print('Details:');
            for (final detail in section.content as List) {
              print('  - $detail');
            }
            break;

          case SectionType.code:
            print('Code (${section.language}):');
            print(section.content);
            break;
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 3: Using with environment variable
  static Future<void> envVariableExample() async {
    // API key loaded from environment
    final service = InterviewService();

    try {
      final response = await service.askQuestion(
        'What are the SOLID principles?',
      );

      print(service.formatResponse(response));
    } catch (e) {
      print('Error: $e');
    }
  }
}
