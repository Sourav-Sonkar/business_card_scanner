import 'package:flutter_test/flutter_test.dart';
import 'package:business_card_scanner/business_card_scanner.dart';

void main() {
  group('TextParser', () {
    late TextParser parser;

    setUp(() {
      parser = const TextParser();
    });

    test('should extract emails correctly', () {
      const testText = '''
      John Doe
      Software Engineer
      john.doe@company.com
      secondary@email.org
      Phone: +1-555-123-4567
      ''';

      final result = parser.parse(testText);

      expect(result.emails.length, equals(2));
      expect(result.emails, contains('john.doe@company.com'));
      expect(result.emails, contains('secondary@email.org'));
      expect(result.rawText, equals(testText));
    });

    test('should extract phone numbers correctly', () {
      const testText = '''
      John Doe
      Phone: +1-555-123-4567
      Mobile: (555) 987-6543
      Office: 555.111.2222
      ''';

      final result = parser.parse(testText);

      expect(result.phones.isNotEmpty, isTrue);
      expect(result.phones, contains('+1-555-123-4567'));
      expect(result.phones, contains('(555) 987-6543'));
      print('Extracted phones: ${result.phones}');
    });

    test('should extract URLs correctly', () {
      const testText = '''
      John Doe
      Website: www.company.com
      Portfolio: https://johndoe.dev
      LinkedIn: linkedin.com/in/johndoe
      ''';

      final result = parser.parse(testText);

      expect(result.urls.isNotEmpty, isTrue);
      expect(result.urls, contains('www.company.com'));
      expect(result.urls, contains('https://johndoe.dev'));
      expect(result.urls, contains('linkedin.com/in/johndoe'));
      print('Extracted URLs: ${result.urls}');
    });

    test('should handle text with no contact information', () {
      const testText = '''
      This is just some random text
      with no emails, phones, or URLs
      in it at all.
      ''';

      final result = parser.parse(testText);

      expect(result.emails, isEmpty);
      expect(result.phones, isEmpty);
      expect(result.urls, isEmpty);
      expect(result.rawText, equals(testText));
    });

    test('should handle empty text', () {
      const testText = '';

      final result = parser.parse(testText);

      expect(result.emails, isEmpty);
      expect(result.phones, isEmpty);
      expect(result.urls, isEmpty);
      expect(result.rawText, equals(testText));
    });

    test('should extract multiple instances of same type', () {
      const testText = '''
      Contact us at:
      Email: info@company.com
      Support: support@company.com
      Sales: sales@company.com
      
      Phone: +1-555-123-4567
      Fax: +1-555-123-4568
      
      Website: www.company.com
      Blog: blog.company.com
      ''';

      final result = parser.parse(testText);

      expect(result.emails.length, greaterThanOrEqualTo(3));
      expect(result.phones.length, greaterThanOrEqualTo(2));
      expect(result.urls.length, greaterThanOrEqualTo(2));
    });

    test('should remove duplicates', () {
      const testText = '''
      Email: john@company.com
      Also reach me at: john@company.com
      My email is john@company.com
      ''';

      final result = parser.parse(testText);

      expect(result.emails.length, equals(1));
      expect(result.emails.first, equals('john@company.com'));
    });
  });
}