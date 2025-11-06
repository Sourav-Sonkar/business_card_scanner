import 'dart:typed_data';
import 'dart:ui';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:logger/logger.dart';
import 'package:image/image.dart' as img;

/// Service for performing OCR on business card images
class OcrService {
  final TextRecognizer _textRecognizer;
  final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 0,
      errorMethodCount: 5,
      colors: true,
      printEmojis: true,
    ),
  );

  /// Creates a new OcrService instance
  OcrService() : _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  /// Recognizes text in the given image
  /// 
  /// [imageBytes] - The image data as Uint8List
  /// Returns a [Future] that completes with the recognized text
  Future<String> recognizeText(Uint8List imageBytes) async {
    try {
      _logger.i('Starting text recognition');
      
      // Decode the image to get actual dimensions
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        _logger.e('Failed to decode image');
        return '';
      }
      
      _logger.d('Image dimensions: ${image.width}x${image.height}');
      
      // Convert to grayscale to improve text recognition
      final processedImage = img.grayscale(image);
      final processedBytes = Uint8List.fromList(img.encodeJpg(processedImage));
      
      final inputImage = InputImage.fromBytes(
        bytes: processedBytes,
        metadata: InputImageMetadata(
          size: Size(image.width.toDouble(), image.height.toDouble()),
          rotation: InputImageRotation.rotation0deg,
          format: InputImageFormat.bgra8888,
          bytesPerRow: image.width * 4, // 4 bytes per pixel for BGRA
        ),
      );
      
      _logger.d('🔍 Processing image for text recognition...');
      final Stopwatch stopwatch = Stopwatch()..start();
      
      try {
        final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);
        final String result = recognizedText.text.trim();
        
        stopwatch.stop();
        _logger.i('✅ Text recognition completed in ${stopwatch.elapsedMilliseconds}ms. Found ${result.length} characters');
        _logger.d('Extracted text: $result');
        
        if (result.isEmpty) {
          _logger.w('⚠️ No text was recognized in the image');
        } else {
          _logger.i('First 100 chars: ${result.length > 100 ? '${result.substring(0, 100)}...' : result}');
        }
        
        return result;
      } catch (e, stackTrace) {
        stopwatch.stop();
        _logger.e('❌ Error during text recognition after ${stopwatch.elapsedMilliseconds}ms', 
                 error: e, stackTrace: stackTrace);
        rethrow;
      }
    } catch (e, stackTrace) {
      _logger.e('❌ Fatal error in text recognition', error: e, stackTrace: stackTrace);
      rethrow;
    }
  }
  

  /// Disposes of resources used by the OCR service
  void dispose() {
    _textRecognizer.close();
    _logger.d('OCR service disposed');
  }
}
