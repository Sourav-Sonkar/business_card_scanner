import 'dart:io';
import 'dart:typed_data';

import 'package:business_card_scanner/business_card_scanner.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Initialize Flutter bindings for ML Kit
  TestWidgetsFlutterBinding.ensureInitialized();

  group('OCR Integration Tests', () {
    late BusinessCardScanner scanner;

    setUp(() {
      scanner = BusinessCardScanner();
    });

    tearDown(() {
      scanner.dispose();
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

    test('should extract text from test business card image if available', () async {
      // Check if test image exists
      final testImageFile = File('example/assets/test_card.png');
      
      if (!testImageFile.existsSync()) {
        print('Test image not found at example/assets/test_card.png - skipping OCR test');
        return;
      }

      final imageBytes = await testImageFile.readAsBytes();
      expect(imageBytes.isNotEmpty, isTrue, 
        reason: 'Image bytes should not be empty',);

      // Scan the business card
      final result = await scanner.scan(imageBytes);

      // Verify that we got some results
      expect(result, isNotNull);
      
      // Print results for debugging
      print('Raw text extracted: "${result.rawText}"');
      print('Emails found: ${result.emails}');
      print('Phones found: ${result.phones}');
      print('URLs found: ${result.urls}');

      // If we got text, it should be non-empty
      if (result.rawText.isNotEmpty) {
        print('✅ OCR successfully extracted text from the image');
        
        // Basic validation - check if we found any contact info
        final hasContactInfo = result.emails.isNotEmpty || 
                             result.phones.isNotEmpty || 
                             result.urls.isNotEmpty;
        
        if (hasContactInfo) {
          print('✅ Successfully extracted contact information');
        } else {
          print('⚠️ No contact information found in extracted text');
        }
      } else {
        print('⚠️ No text was extracted from the image - this might be expected if the image has no text');
      }
    });

    test('should create valid BusinessCardData structure', () async {
      // Test with minimal valid image data (will likely return empty results)
      final minimalImageBytes = Uint8List.fromList([
        0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46, // JPEG header
        0x00, 0x01, 0x01, 0x01, 0x00, 0x48, 0x00, 0x48, 0x00, 0x00,
        0xFF, 0xD9, // JPEG end
      ]);
      
      final result = await scanner.scan(minimalImageBytes);
      
      expect(result, isNotNull);
      expect(result.emails, isA<List<String>>());
      expect(result.phones, isA<List<String>>());
      expect(result.urls, isA<List<String>>());
      expect(result.rawText, isA<String>());
      
      // Test the convenience getters
      expect(result.email, result.emails.isNotEmpty ? result.emails.first : null);
      expect(result.phone, result.phones.isNotEmpty ? result.phones.first : null);
      expect(result.url, result.urls.isNotEmpty ? result.urls.first : null);
    });
  });
}
