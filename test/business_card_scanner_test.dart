import 'dart:io';
import 'dart:typed_data';

import 'package:business_card_scanner/business_card_scanner.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Initialize Flutter bindings for ML Kit
  TestWidgetsFlutterBinding.ensureInitialized();
  group('BusinessCardScanner', () {
    late BusinessCardScanner scanner;

    setUp(() {
      scanner = BusinessCardScanner();
    });

    tearDown(() {
      scanner.dispose();
    });

    test('should extract text from test business card image', () async {
      // Load the test image from assets
      final testImageFile = File('example/assets/test_card.png');
      expect(testImageFile.existsSync(), isTrue, 
        reason: 'Test image should exist at example/assets/test_card.png',);

      final imageBytes = await testImageFile.readAsBytes();
      expect(imageBytes.isNotEmpty, isTrue, 
        reason: 'Image bytes should not be empty',);

      // Scan the business card
      final result = await scanner.scan(imageBytes);

      // Verify that we got some results
      expect(result, isNotNull);
      expect(result.rawText, isNotEmpty, 
        reason: 'Should extract some text from the business card',);

      // Print results for debugging
      print('Raw text extracted: ${result.rawText}');
      print('Emails found: ${result.emails}');
      print('Phones found: ${result.phones}');
      print('URLs found: ${result.urls}');

      // Basic validation - at least one of these should be found in a business card
      final hasContactInfo = result.emails.isNotEmpty || 
                           result.phones.isNotEmpty || 
                           result.urls.isNotEmpty;
      
      expect(hasContactInfo, isTrue, 
        reason: 'Should find at least one email, phone, or URL in a business card',);
    });

    test('should handle empty image gracefully', () async {
      final emptyBytes = Uint8List(0);
      
      // This should not throw an exception
      final result = await scanner.scan(emptyBytes);
      
      expect(result, isNotNull);
      expect(result.rawText, isEmpty);
      expect(result.emails, isEmpty);
      expect(result.phones, isEmpty);
      expect(result.urls, isEmpty);
    });

    test('should extract emails correctly', () {
      const testText = '''
      John Doe
      Software Engineer
      john.doe@company.com
      secondary@email.org
      Phone: +1-555-123-4567
      ''';

      const parser = TextParser();
      final result = parser.parse(testText);

      expect(result.emails.length, equals(2));
      expect(result.emails, contains('john.doe@company.com'));
      expect(result.emails, contains('secondary@email.org'));
    });

    test('should extract phone numbers correctly', () {
      const testText = '''
      John Doe
      Phone: +1-555-123-4567
      Mobile: (555) 987-6543
      Office: 555.111.2222
      ''';

      const parser = TextParser();
      final result = parser.parse(testText);

      expect(result.phones.isNotEmpty, isTrue);
      print('Extracted phones: ${result.phones}');
    });

    test('should extract URLs correctly', () {
      const testText = '''
      John Doe
      Website: www.company.com
      Portfolio: https://johndoe.dev
      LinkedIn: linkedin.com/in/johndoe
      ''';

      const parser = TextParser();
      final result = parser.parse(testText);

      expect(result.urls.isNotEmpty, isTrue);
      print('Extracted URLs: ${result.urls}');
    });
  });
}
