import 'package:flutter_test/flutter_test.dart';
import 'package:business_card_scanner/business_card_scanner.dart';

void main() {
  group('BusinessCardData', () {
    test('should create BusinessCardData with all fields', () {
      final data = BusinessCardData(
        rawText: 'Sample business card text',
        emails: ['john@company.com', 'info@company.com'],
        phones: ['+1-555-123-4567', '(555) 987-6543'],
        urls: ['www.company.com', 'https://company.com'],
        name: 'John Doe',
        title: 'Software Engineer',
        company: 'Tech Company Inc.',
        address: '123 Main St, City, State 12345',
      );

      expect(data.rawText, equals('Sample business card text'));
      expect(data.emails.length, equals(2));
      expect(data.phones.length, equals(2));
      expect(data.urls.length, equals(2));
      expect(data.name, equals('John Doe'));
      expect(data.title, equals('Software Engineer'));
      expect(data.company, equals('Tech Company Inc.'));
      expect(data.address, equals('123 Main St, City, State 12345'));
    });

    test('should provide convenience getters', () {
      final data = BusinessCardData(
        rawText: 'Test',
        emails: ['first@test.com', 'second@test.com'],
        phones: ['123-456-7890', '098-765-4321'],
        urls: ['www.test.com', 'blog.test.com'],
      );

      expect(data.email, equals('first@test.com'));
      expect(data.phone, equals('123-456-7890'));
      expect(data.url, equals('www.test.com'));
    });

    test('should return null for empty lists', () {
      final data = BusinessCardData(
        rawText: 'Test',
        emails: [],
        phones: [],
        urls: [],
      );

      expect(data.email, isNull);
      expect(data.phone, isNull);
      expect(data.url, isNull);
    });

    test('should merge two BusinessCardData objects', () {
      final data1 = BusinessCardData(
        rawText: 'Original text',
        emails: ['email1@test.com'],
        phones: ['123-456-7890'],
        urls: ['www.test.com'],
        name: 'John Doe',
      );

      final data2 = BusinessCardData(
        rawText: 'Additional text',
        emails: ['email2@test.com'],
        phones: ['098-765-4321'],
        urls: ['blog.test.com'],
        title: 'Software Engineer',
        company: 'Tech Corp',
      );

      final merged = data1.merge(data2);

      expect(merged.rawText, equals('Original text')); // Keeps original
      expect(merged.emails.length, equals(2));
      expect(merged.phones.length, equals(2));
      expect(merged.urls.length, equals(2));
      expect(merged.name, equals('John Doe')); // Keeps original
      expect(merged.title, equals('Software Engineer')); // Takes from other
      expect(merged.company, equals('Tech Corp')); // Takes from other
    });

    test('should convert to and from map', () {
      final originalData = BusinessCardData(
        rawText: 'Test card text',
        emails: ['test@example.com'],
        phones: ['555-1234'],
        urls: ['www.example.com'],
        name: 'Test User',
        title: 'Developer',
        company: 'Test Corp',
        address: '123 Test St',
      );

      final map = originalData.toMap();
      final recreatedData = BusinessCardData.fromMap(map, originalData.rawText);

      expect(recreatedData.rawText, equals(originalData.rawText));
      expect(recreatedData.emails, equals(originalData.emails));
      expect(recreatedData.phones, equals(originalData.phones));
      expect(recreatedData.urls, equals(originalData.urls));
      expect(recreatedData.name, equals(originalData.name));
      expect(recreatedData.title, equals(originalData.title));
      expect(recreatedData.company, equals(originalData.company));
      expect(recreatedData.address, equals(originalData.address));
    });

    test('should have proper toString representation', () {
      final data = BusinessCardData(
        rawText: 'Short text',
        emails: ['test@example.com'],
        phones: ['555-1234'],
        urls: ['www.example.com'],
      );

      final stringRep = data.toString();
      expect(stringRep, contains('BusinessCardData'));
      expect(stringRep, contains('test@example.com'));
      expect(stringRep, contains('555-1234'));
      expect(stringRep, contains('www.example.com'));
    });
  });
}