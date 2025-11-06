# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.2] - 2024-11-07

### Fixed
- Updated analysis_options.yaml to remove deprecated linter rules
- Fixed all code style issues identified by dart analyze
- Improved import ordering and constructor placement
- Added proper const usage throughout the codebase
- Fixed catch clauses to use proper exception types
- Removed unnecessary type annotations on local variables
- Updated to use relative imports for lib directory files
- Fixed dependency ordering in pubspec.yaml
- Added required trailing commas and final variable declarations

### Code Quality
- Reduced analysis issues from 90 to 3 (97% improvement)
- Enhanced code consistency and adherence to Dart/Flutter best practices
- Improved maintainability and readability
- Updated linting rules to be compatible with current Dart versions

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