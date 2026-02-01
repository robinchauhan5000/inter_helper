# Interview Assistant API Integration

## Overview

This implementation provides a clean, structured way to interact with OpenAI's GPT-4o-mini model for interview assistance.

## Architecture

```
lib/
├── config/
│   └── api_config.dart          # API configuration
├── models/
│   ├── interview_response.dart  # Response models
│   └── models.dart              # Barrel export
├── services/
│   ├── http_client.dart         # Generic HTTP client
│   ├── openai_service.dart      # OpenAI API integration
│   ├── interview_service.dart   # High-level service
│   └── services.dart            # Barrel export
└── examples/
    └── interview_service_example.dart
```

## Setup

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Configure API Key

**Option A: Environment Variable (Recommended)**

```bash
flutter run --dart-define=OPENAI_API_KEY=your-api-key-here
```

**Option B: Pass Directly**

```dart
final service = InterviewService(apiKey: 'your-api-key-here');
```

## Usage

### Basic Example

```dart
import 'package:hexmac/services/services.dart';

Future<void> main() async {
  final service = InterviewService(
    apiKey: 'your-openai-api-key-here',
  );

  final response = await service.askQuestion(
    'Explain what is a closure in JavaScript',
  );

  print(service.formatResponse(response));
}
```

### Handling Structured Response

```dart
final response = await service.askQuestion('Your question here');

// Access title
print(response.title);

// Process sections
for (final section in response.sections) {
  switch (section.type) {
    case SectionType.shortAnswer:
      print('Answer: ${section.content}');
      break;

    case SectionType.details:
      for (final detail in section.content as List) {
        print('• $detail');
      }
      break;

    case SectionType.code:
      print('Language: ${section.language}');
      print('Code: ${section.content}');
      break;
  }
}
```

## Response Schema

The API returns responses in this structure:

```json
{
  "title": "Closures in JavaScript",
  "sections": [
    {
      "type": "short_answer",
      "content": "A closure is a function that has access to variables in its outer scope."
    },
    {
      "type": "details",
      "content": [
        "Closures are created when a function is defined inside another function",
        "They maintain access to the outer function's variables even after it returns",
        "Commonly used for data privacy and factory functions"
      ]
    },
    {
      "type": "code",
      "language": "javascript",
      "content": "function outer() {\n  let count = 0;\n  return function inner() {\n    count++;\n    return count;\n  };\n}"
    }
  ]
}
```

## Section Types

- **short_answer**: Brief, direct answer to the question
- **details**: List of key points or bullet points
- **code**: Code snippet with language specification

## Error Handling

```dart
try {
  final response = await service.askQuestion('Your question');
  print(service.formatResponse(response));
} on OpenAIException catch (e) {
  print('OpenAI API error: $e');
} on ArgumentError catch (e) {
  print('Invalid input: $e');
} catch (e) {
  print('Unexpected error: $e');
}
```

## Features

- ✅ Clean separation of concerns
- ✅ Type-safe models
- ✅ Structured JSON responses
- ✅ GPT-4o-mini model
- ✅ Comprehensive error handling
- ✅ Timeout configuration
- ✅ Environment variable support
- ✅ Easy to test and mock

## Model Information

- **Model**: `gpt-4o-mini`
- **Temperature**: 0.7 (balanced creativity)
- **Response Format**: JSON object
- **Timeout**: 60 seconds

## Security Notes

- Never commit API keys to version control
- Use environment variables or secure storage
- Consider implementing rate limiting
- Add request validation for production use
