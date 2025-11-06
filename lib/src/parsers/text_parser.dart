import 'package:business_card_scanner/src/models/business_card_data.dart';

/// A utility class for parsing text from business cards
class TextParser {
  /// Creates a new TextParser instance
  const TextParser();
  static const String _emailPattern = r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}';
  static const String _phonePattern = r'(\+?\d{1,3}[\s-]?)?(?:\(?\d{2,4}\)?[\s-]?)?\d{3,4}[\s-]?\d{3,4}';
  static const String _urlPattern = r'(https?:\/\/)?(www\.)?[\w\-]+\.[\w\-\.]+[^\s,;]*';

  static final RegExp _emailRegex = RegExp(
    _emailPattern,
    caseSensitive: false,
    multiLine: true,
  );

  static final RegExp _phoneRegex = RegExp(
    _phonePattern,
    multiLine: true,
  );

  static final RegExp _urlRegex = RegExp(
    _urlPattern,
    caseSensitive: false,
    multiLine: true,
  );

  /// Parses the given text to extract business card information
  /// 
  /// [text] - The text to parse
  /// Returns a [BusinessCardData] object with the extracted information
  BusinessCardData parse(String text) {
    // Extract emails
    final List<RegExpMatch> emailMatches = _emailRegex.allMatches(text).toList();
    final List<String> emails = emailMatches
        .map((RegExpMatch match) => match.group(0)!)
        .toSet()
        .toList(growable: false);

    // Extract phone numbers
    final List<RegExpMatch> phoneMatches = _phoneRegex.allMatches(text).toList();
    final List<String> phones = phoneMatches
        .map((RegExpMatch match) => match.group(0)!)
        .toSet()
        .toList(growable: false);

    // Extract URLs
    final List<RegExpMatch> urlMatches = _urlRegex.allMatches(text).toList();
    final List<String> urls = urlMatches
        .map((RegExpMatch match) => match.group(0)!)
        .toSet()
        .toList(growable: false);

    return BusinessCardData(
      rawText: text,
      emails: emails,
      phones: phones,
      urls: urls,
    );
  }
}
