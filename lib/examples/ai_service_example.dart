import '../services/interview_service.dart';

/// Example usage of AI services
void main() async {
  // Example 1: Using OpenAI
  print('=== OpenAI Example ===');
  final openaiService = InterviewService(provider: AIProvider.openai);

  try {
    final response = await openaiService.askQuestion(
      'What is a closure in JavaScript?',
    );
    print(openaiService.formatResponse(response));
  } catch (e) {
    print('OpenAI Error: $e');
  }

  // Example 2: Using Gemini
  print('\n=== Gemini Example ===');
  final geminiService = InterviewService(provider: AIProvider.gemini);

  try {
    final response = await geminiService.askQuestion(
      'Explain async/await in Python',
    );
    print(geminiService.formatResponse(response));
  } catch (e) {
    print('Gemini Error: $e');
  }

  // Example 3: Using custom API key
  print('\n=== Custom API Key Example ===');
  final customService = InterviewService(
    provider: AIProvider.openai,
    apiKey: 'your-custom-api-key',
  );

  try {
    final response = await customService.askQuestion(
      'What is dependency injection?',
    );
    print(customService.formatResponse(response));
  } catch (e) {
    print('Custom Service Error: $e');
  }
}
