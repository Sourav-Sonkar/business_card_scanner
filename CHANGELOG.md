# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2024-11-07

### Changed
- Enhanced README.md with comprehensive documentation for GeneralOcrService
- Added complete API reference tables for all classes and methods
- Included practical usage examples with image picker integration
- Added platform setup instructions for Android and iOS
- Added performance tips and troubleshooting section
- Improved roadmap with detailed version planning
- Added contributing guidelines and support links

### Documentation
- Complete examples showing both BusinessCardScanner and GeneralOcrService usage
- Detailed API documentation for BusinessCardData and OcrResult classes
- Platform-specific configuration instructions
- Error handling examples and best practices

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