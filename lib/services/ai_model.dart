import '../models/interview_response.dart';

/// Abstract base class for AI model services
abstract class AIModel {
  /// Send a prompt and get structured interview response
  Future<InterviewResponse> getInterviewResponse(String prompt);

  /// Stream response for real-time updates (optional)
  Future<Stream<String>> streamInterviewResponse(String prompt) {
    throw UnimplementedError('Streaming not implemented for this model');
  }
}

/// Custom exception for AI model errors
class AIModelException implements Exception {
  final String message;
  final String? provider;

  AIModelException(this.message, {this.provider});

  @override
  String toString() => provider != null
      ? 'AIModelException ($provider): $message'
      : 'AIModelException: $message';
}
