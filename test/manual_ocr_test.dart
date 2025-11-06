import 'dart:io';

import 'package:business_card_scanner/business_card_scanner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // This test is designed to be run manually to debug OCR issues
  // It will only work when run in a real Flutter app environment
  
  group('Manual OCR Debug Tests', () {
    test('Debug OCR with test image', () async {
      // This test helps debug OCR issues by providing detailed output
      print('🔍 Starting manual OCR debug test...');
      
      // Check if test image exists
      final testImageFile = File('example/assets/test_card.png');
      if (!testImageFile.existsSync()) {
        print('❌ Test image not found at example/assets/test_card.png');
        print('   Please make sure the test image exists');
        return;
      }
      
      print('✅ Test image found');
      final imageBytes = await testImageFile.readAsBytes();
      print('📊 Image size: ${imageBytes.length} bytes');
      
      // Create scanner and test
      final scanner = BusinessCardScanner();
      
      try {
        print('🚀 Starting OCR scan...');
        final result = await scanner.scan(imageBytes);
        
        print('📋 OCR Results:');
        print('   Raw text length: ${result.rawText.length}');
        print('   Emails found: ${result.emails.length}');
        print('   Phones found: ${result.phones.length}');
        print('   URLs found: ${result.urls.length}');
        
        if (result.rawText.isNotEmpty) {
          print('📝 Raw text content:');
          print('   "${result.rawText}"');
        } else {
          print('⚠️  No text was extracted from the image');
          print('   This could mean:');
          print('   1. The image has no readable text');
          print('   2. The text is too small or blurry');
          print('   3. ML Kit is not properly initialized');
        }
        
        if (result.emails.isNotEmpty) {
          print('📧 Emails: ${result.emails}');
        }
        
        if (result.phones.isNotEmpty) {
          print('📞 Phones: ${result.phones}');
        }
        
        if (result.urls.isNotEmpty) {
          print('🌐 URLs: ${result.urls}');
        }
        
      } catch (e, stackTrace) {
        print('❌ Error during OCR: $e');
        print('Stack trace: $stackTrace');
      } finally {
        scanner.dispose();
        print('🧹 Scanner disposed');
      }
    });
    
    test('Test text parsing with known text', () {
      print('🧪 Testing text parsing with known business card text...');
      
      const sampleBusinessCardText = '''
      John Doe
      Software Engineer
      Tech Solutions Inc.
      
      Email: john.doe@techsolutions.com
      Phone: +1 (555) 123-4567
      Mobile: 555.987.6543
      
      Website: www.techsolutions.com
      LinkedIn: linkedin.com/in/johndoe
      
      123 Business Ave
      Suite 100
      Tech City, TC 12345
      ''';
      
      const parser = TextParser();
      final result = parser.parse(sampleBusinessCardText);
      
      print('📋 Parsing Results:');
      print('   Raw text length: ${result.rawText.length}');
      print('   Emails found: ${result.emails}');
      print('   Phones found: ${result.phones}');
      print('   URLs found: ${result.urls}');
      
      // Verify parsing is working
      expect(result.emails.isNotEmpty, isTrue, reason: 'Should find emails');
      expect(result.phones.isNotEmpty, isTrue, reason: 'Should find phones');
      expect(result.urls.isNotEmpty, isTrue, reason: 'Should find URLs');
      
      print('✅ Text parsing is working correctly!');
    });
  });
}
