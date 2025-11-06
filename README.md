# Business Card Scanner

A Flutter package for scanning and extracting information from business cards and general text recognition offline using ML Kit.

## Features

-  **Business Card Scanning**: Extract structured data from business cards
-  **General OCR**: Extract text from any image with metadata
-  **Smart Parsing**: Automatically extract emails, phone numbers, and URLs
-  **Offline Processing**: Uses Google ML Kit for on-device text recognition
-  **Extensible Architecture**: Ready for future AI integration
-  **Platform-agnostic**: Works on iOS, Android, and other Flutter platforms

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  business_card_scanner: ^1.0.0
```

## Usage

### Business Card Scanning

For structured business card data extraction:

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

// Don't forget to dispose
scanner.dispose();
```

### General OCR (Text Recognition)

For general text extraction from any image:

```dart
import 'package:business_card_scanner/business_card_scanner.dart';

// Initialize OCR service
final ocrService = GeneralOcrService();

// Simple text extraction
final text = await ocrService.extractText(imageBytes);
print('Extracted text: $text');

// Text extraction with metadata
final result = await ocrService.extractTextWithMetadata(imageBytes);
print('Text: ${result.text}');
print('Processing time: ${result.processingTimeMs}ms');
print('Word count: ${result.wordCount}');
print('Character count: ${result.characterCount}');
print('Line count: ${result.lineCount}');

// Check if text was found
if (result.hasText) {
  print('Normalized text: ${result.normalizedText}');
  print('Lines: ${result.lines}');
  print('Words: ${result.words}');
}

// Don't forget to dispose
ocrService.dispose();
```

## API Reference

### BusinessCardScanner

| Method | Description | Returns |
|--------|-------------|---------|
| `scan(Uint8List imageBytes)` | Scans business card and extracts structured data | `Future<BusinessCardData>` |
| `dispose()` | Releases resources | `void` |

### GeneralOcrService

| Method | Description | Returns |
|--------|-------------|---------|
| `extractText(Uint8List imageBytes)` | Extracts raw text from image | `Future<String>` |
| `extractTextWithMetadata(Uint8List imageBytes)` | Extracts text with processing metadata | `Future<OcrResult>` |
| `dispose()` | Releases resources | `void` |

### BusinessCardData

| Property | Type | Description |
|----------|------|-------------|
| `email` | `String?` | First email found in the text |
| `phone` | `String?` | First phone number found |
| `url` | `String?` | First URL found |
| `rawText` | `String` | Complete extracted text |

### OcrResult

| Property | Type | Description |
|----------|------|-------------|
| `text` | `String` | Extracted text |
| `processingTimeMs` | `int` | Processing time in milliseconds |
| `characterCount` | `int` | Number of characters |
| `wordCount` | `int` | Number of words |
| `lineCount` | `int` | Number of lines |
| `hasText` | `bool` | Whether any text was found |
| `normalizedText` | `String` | Text with normalized whitespace |
| `lines` | `List<String>` | Text split into lines |
| `words` | `List<String>` | Text split into words |

## Complete Example

Here's a practical example showing both business card scanning and general OCR:

```dart
import 'dart:typed_data';
import 'package:business_card_scanner/business_card_scanner.dart';
import 'package:image_picker/image_picker.dart';

class DocumentScanner {
  final BusinessCardScanner _businessCardScanner = BusinessCardScanner();
  final GeneralOcrService _ocrService = GeneralOcrService();

  Future<void> scanBusinessCard() async {
    // Pick image from gallery or camera
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    
    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      
      // Scan business card for structured data
      final businessCardData = await _businessCardScanner.scan(imageBytes);
      
      print('📧 Email: ${businessCardData.email ?? 'Not found'}');
      print('📞 Phone: ${businessCardData.phone ?? 'Not found'}');
      print('🌐 Website: ${businessCardData.url ?? 'Not found'}');
      print('📄 Full text: ${businessCardData.rawText}');
    }
  }

  Future<void> scanDocument() async {
    // Pick image from gallery or camera
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final Uint8List imageBytes = await image.readAsBytes();
      
      // Extract text with metadata
      final ocrResult = await _ocrService.extractTextWithMetadata(imageBytes);
      
      print('📝 Text found: ${ocrResult.hasText}');
      print('⏱️ Processing time: ${ocrResult.processingTimeMs}ms');
      print('📊 Statistics:');
      print('   - Characters: ${ocrResult.characterCount}');
      print('   - Words: ${ocrResult.wordCount}');
      print('   - Lines: ${ocrResult.lineCount}');
      print('📄 Content: ${ocrResult.normalizedText}');
    }
  }

  void dispose() {
    _businessCardScanner.dispose();
    _ocrService.dispose();
  }
}
```

## Platform Setup

### Android
Add the following to your `android/app/build.gradle`:

```gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

### iOS
Add camera and photo library permissions to your `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access to scan business cards</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs photo library access to select images for scanning</string>
```

## Example Apps

The package includes two complete example apps:

- **Business Card Scanner** (`example/lib/main.dart`): Demonstrates structured business card scanning with camera integration
- **General OCR Demo** (`example/lib/general_ocr_demo.dart`): Shows general text recognition capabilities with performance metrics

Run the examples:
```bash
cd example
flutter run
```

## Performance Tips

- **Image Quality**: Higher resolution images generally produce better OCR results
- **Lighting**: Ensure good lighting conditions when capturing images
- **Text Orientation**: The package works best with horizontally oriented text
- **Memory Management**: Always call `dispose()` to free up resources
- **Processing Time**: OCR processing time varies based on image size and complexity

## Troubleshooting

### Common Issues

**No text detected:**
- Ensure good lighting and image quality
- Check that the image contains readable text
- Verify that ML Kit is properly initialized (may require app restart)

**Poor extraction accuracy:**
- Use higher resolution images
- Ensure text is horizontally oriented
- Avoid blurry or low-contrast images

**Performance issues:**
- Resize large images before processing
- Process images on a background isolate for better UI performance
- Always dispose of services when done

### Error Handling

```dart
try {
  final result = await scanner.scan(imageBytes);
  // Handle successful scan
} catch (e) {
  print('Scan failed: $e');
  // Handle error (show user-friendly message)
}
```

## Roadmap

### v1.0 (Current)
- [x] Offline text recognition using ML Kit
- [x] Business card structured data extraction
- [x] General OCR with metadata
- [x] Email, phone, and URL parsing
- [x] Complete example applications
- [x] Comprehensive documentation

### v1.1 (Next)
- [ ] Improved regex patterns for better extraction
- [ ] Support for more phone number formats
- [ ] Text confidence scores
- [ ] Batch processing capabilities

### v2.0 (Future)
- [ ] AI-based field extraction (name, title, company)
- [ ] Multi-language support
- [ ] Custom field extraction rules
- [ ] Integration with contact management systems
- [ ] Advanced image preprocessing

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## License

MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📚 [Documentation](https://pub.dev/packages/business_card_scanner)
- 🐛 [Issue Tracker](https://github.com/Sourav-Sonkar/business_card_scanner/issues)
- 💬 [Discussions](https://github.com/Sourav-Sonkar/business_card_scanner/discussions)
