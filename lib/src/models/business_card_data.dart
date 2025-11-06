import 'package:flutter/foundation.dart';

/// Represents the structured data extracted from a business card
@immutable
class BusinessCardData {
  /// Creates a new BusinessCardData instance
  BusinessCardData({
    required this.rawText,
    List<String> emails = const [],
    List<String> phones = const [],
    List<String> urls = const [],
    this.name,
    this.title,
    this.company,
    this.address,
  })  : emails = List<String>.unmodifiable(emails),
        phones = List<String>.unmodifiable(phones),
        urls = List<String>.unmodifiable(urls);

  /// Creates a BusinessCardData from a map
  factory BusinessCardData.fromMap(Map<String, dynamic> map, String rawText) {
    return BusinessCardData(
      rawText: rawText,
      emails: List<String>.from(map['emails'] as List<dynamic>? ?? <dynamic>[]),
      phones: List<String>.from(map['phones'] as List<dynamic>? ?? <dynamic>[]),
      urls: List<String>.from(map['urls'] as List<dynamic>? ?? <dynamic>[]),
      name: map['name'] as String?,
      title: map['title'] as String?,
      company: map['company'] as String?,
      address: map['address'] as String?,
    );
  }
  /// Raw text extracted from the business card
  final String rawText;

  /// List of email addresses found
  final List<String> emails;

  /// List of phone numbers found
  final List<String> phones;

  /// List of URLs/websites found
  final List<String> urls;

  /// Name of the person (available in v2 with AI)
  final String? name;

  /// Job title (available in v2 with AI)
  final String? title;

  /// Company name (available in v2 with AI)
  final String? company;

  /// Address (available in v2 with AI)
  final String? address;


  /// Converts the BusinessCardData to a map
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'emails': emails,
      'phones': phones,
      'urls': urls,
      'name': name,
      'title': title,
      'company': company,
      'address': address,
      'rawText': rawText,
    };
  }

  /// Merges this BusinessCardData with another one
  BusinessCardData merge(BusinessCardData other) {
    final mergedEmails = <String>{...emails, ...other.emails};
    final mergedPhones = <String>{...phones, ...other.phones};
    final mergedUrls = <String>{...urls, ...other.urls};
    
    return BusinessCardData(
      rawText: rawText,
      emails: mergedEmails.toList(),
      phones: mergedPhones.toList(),
      urls: mergedUrls.toList(),
      name: other.name ?? name,
      title: other.title ?? title,
      company: other.company ?? company,
      address: other.address ?? address,
    );
  }

  /// Get the first email or null if none exists
  String? get email => emails.isNotEmpty ? emails.first : null;

  /// Get the first phone number or null if none exists
  String? get phone => phones.isNotEmpty ? phones.first : null;

  /// Get the first URL or null if none exists
  String? get url => urls.isNotEmpty ? urls.first : null;

  /// Returns a string representation of the BusinessCardData
  @override
  String toString() {
    return 'BusinessCardData{\n'
        '  emails: $emails,\n'
        '  phones: $phones,\n'
        '  urls: $urls,\n'
        '  name: $name,\n'
        '  title: $title,\n'
        '  company: $company,\n'
        '  address: $address,\n'
        '  rawText: ${rawText.length > 50 ? '${rawText.substring(0, 50)}...' : rawText}\n'
        '}';
  }
}
