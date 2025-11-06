import 'dart:io';
import 'dart:typed_data';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

/// Service for performing OCR on business card images
class OcrService {
  /// Creates a new OcrService instance
  OcrService() : _textRecognizer = TextRecognizer();

  final TextRecognizer _textRecognizer;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
    ),
  );

  /// Recognizes text in the given image
  /// 
  /// [imageBytes] - The image data as Uint8List
  /// Returns a [Future] that completes with the recognized text
  Future<String> recognizeText(Uint8List imageBytes) async {
    File? tempFile;
    try {
      _logger.i('Starting text recognition');
      
      // Create a temporary file from the image bytes
      // This is more reliable than trying to create InputImage from bytes with metadata
      final tempDir = await getTemporaryDirectory();
      tempFile = File('${tempDir.path}/temp_business_card_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await tempFile.writeAsBytes(imageBytes);
      
      // Create InputImage from file path - this is the most reliable approach
      final inputImage = InputImage.fromFilePath(tempFile.path);
      
      _logger.d('🔍 Processing image for text recognition...');
      final stopwatch = Stopwatch()..start();
      
      final recognizedText = await _textRecognizer.processImage(inputImage);
      final result = recognizedText.text.trim();
      
      stopwatch.stop();
      _logger.i('✅ Text recognition completed in ${stopwatch.elapsedMilliseconds}ms. Found ${result.length} characters');
      
      if (result.isEmpty) {
        _logger.w('⚠️ No text was recognized in the image');
      } else {
        _logger.i('📝 Extracted text preview: ${result.length > 100 ? '${result.substring(0, 100)}...' : result}');
      }
      
      return result;
    } on Exception catch (e, stackTrace) {
      _logger.e('❌ Error in text recognition: $e', stackTrace: stackTrace);
      // Return empty string instead of rethrowing to prevent app crashes
      return '';
    } finally {
      // Clean up temporary file
      if (tempFile != null && tempFile.existsSync()) {
        try {
          await tempFile.delete();
          _logger.d('🗑️ Cleaned up temporary file');
        } on Exception catch (e) {
          _logger.w('Failed to delete temporary file: $e');
        }
      }
    }
  }
  

  /// Disposes of resources used by the OCR service
  void dispose() {
    _textRecognizer.close();
    _logger.d('OCR service disposed');
  }
}
