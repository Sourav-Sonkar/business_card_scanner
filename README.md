# Business Card Scanner

A Flutter package for scanning and extracting information from business cards offline using ML Kit.

## Features

- 📱 Scan business cards using device camera or gallery
- 🔍 Offline text recognition using Google ML Kit
- 📝 Extract emails, phone numbers, and URLs using regex
- 🏗️ Extensible architecture for future AI integration
- 📱 Platform-agnostic implementation

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  business_card_scanner: ^1.0.0
```

## Usage

```dart
import 'package:business_card_scanner/business_card_scanner.dart';

// Initialize scanner
final scanner = BusinessCardScanner();

// Scan from image bytes
final result = await scanner.scan(imageBytes);

// Access extracted data
print('Email: ${result.email}');
print('Phone: ${result.phone}');
print('URL: ${result.url}');
print('Raw text: ${result.rawText}');
```

## Example

See the `example/` directory for a complete example app.

## Roadmap

### v1 (Current)
- [x] Offline text recognition
- [x] Basic contact info extraction (email, phone, URL)
- [x] Simple regex-based parsing

### v2 (Planned)
- [ ] AI-based field extraction (name, title, company)
- [ ] Improved text parsing accuracy
- [ ] Support for more contact information types

## License

MIT
