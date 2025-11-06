# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2024-11-07

### Added
- Initial release of business_card_scanner package
- Offline text recognition using Google ML Kit
- Extract emails, phone numbers, and URLs from business cards
- Support for scanning from camera or gallery
- Comprehensive test suite
- Example application demonstrating usage
- Platform-agnostic implementation for Flutter

### Features
- `BusinessCardScanner` class for scanning business cards
- `BusinessCardData` model for structured data extraction
- `GeneralOcrService` for general text recognition
- Regex-based parsing for contact information
- Extensible architecture for future AI integration