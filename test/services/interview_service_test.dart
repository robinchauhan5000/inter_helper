import 'package:flutter_test/flutter_test.dart';
import 'package:hexmac/models/models.dart';

void main() {
  group('InterviewResponse Model Tests', () {
    test('should parse valid JSON response', () {
      final json = {
        'title': 'Test Title',
        'sections': [
          {'type': 'short_answer', 'content': 'This is a short answer'},
          {
            'type': 'details',
            'content': ['Point 1', 'Point 2', 'Point 3'],
          },
          {
            'type': 'code',
            'language': 'dart',
            'content': 'void main() { print("Hello"); }',
          },
        ],
      };

      final response = InterviewResponse.fromJson(json);

      expect(response.title, 'Test Title');
      expect(response.sections.length, 3);
      expect(response.sections[0].type, SectionType.shortAnswer);
      expect(response.sections[1].type, SectionType.details);
      expect(response.sections[2].type, SectionType.code);
      expect(response.sections[2].language, 'dart');
    });

    test('should convert to JSON correctly', () {
      final response = InterviewResponse(
        title: 'Test',
        sections: [
          const ResponseSection(
            type: SectionType.shortAnswer,
            content: 'Answer',
          ),
          const ResponseSection(
            type: SectionType.code,
            content: 'code here',
            language: 'python',
          ),
        ],
      );

      final json = response.toJson();

      expect(json['title'], 'Test');
      expect(json['sections'].length, 2);
      expect(json['sections'][0]['type'], 'short_answer');
      expect(json['sections'][1]['language'], 'python');
    });
  });

  group('SectionType Tests', () {
    test('should convert from string correctly', () {
      expect(SectionType.fromString('short_answer'), SectionType.shortAnswer);
      expect(SectionType.fromString('details'), SectionType.details);
      expect(SectionType.fromString('code'), SectionType.code);
    });

    test('should handle invalid type gracefully', () {
      expect(SectionType.fromString('invalid'), SectionType.shortAnswer);
    });
  });
}
