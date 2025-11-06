import 'dart:typed_data';

import 'ocr_service.dart';

/// A general-purpose OCR service that can extract text from any image
class GeneralOcrService {
  /// Creates a new GeneralOcrService instance
  GeneralOcrService() : _ocrService = OcrService();

  final OcrService _ocrService;

  /// Extracts all text from an image
  /// 
  /// [imageBytes] - The image data as Uint8List
  /// Returns a [Future] that completes with the extracted text
  Future<String> extractText(Uint8List imageBytes) async {
    return _ocrService.recognizeText(imageBytes);
  }

  /// Extracts text with additional metadata
  /// 
  /// [imageBytes] - The image data as Uint8List
  /// Returns a [Future] that completes with [OcrResult] containing text and metadata
  Future<OcrResult> extractTextWithMetadata(Uint8List imageBytes) async {
    final stopwatch = Stopwatch()..start();
    final text = await _ocrService.recognizeText(imageBytes);
    stopwatch.stop();

    return OcrResult(
      text: text,
      processingTimeMs: stopwatch.elapsedMilliseconds,
      characterCount: text.length,
      wordCount: text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length,
      lineCount: text.trim().isEmpty ? 0 : text.split('\n').length,
    );
  }

  /// Disposes of resources
  void dispose() {
    _ocrService.dispose();
  }
}

/// Result of OCR processing with metadata
class OcrResult {
  /// Creates a new OcrResult
  const OcrResult({
    required this.text,
    required this.processingTimeMs,
    required this.characterCount,
    required this.wordCount,
    required this.lineCount,
  });

  /// The extracted text
  final String text;
  
  /// Processing time in milliseconds
  final int processingTimeMs;
  
  /// Number of characters found
  final int characterCount;
  
  /// Number of words found
  final int wordCount;
  
  /// Number of lines found
  final int lineCount;

  /// Returns true if any text was found
  bool get hasText => text.trim().isNotEmpty;

  /// Returns the text with normalized whitespace
  String get normalizedText => text.trim().replaceAll(RegExp(r'\s+'), ' ');

  /// Returns the text split into lines
  List<String> get lines => text.split('\n').where((line) => line.trim().isNotEmpty).toList();

  /// Returns the text split into words
  List<String> get words => text.trim().isEmpty ? [] : text.trim().split(RegExp(r'\s+'));

  @override
  String toString() {
    return 'OcrResult{\n'
        '  text: "${text.length > 50 ? '${text.substring(0, 50)}...' : text}",\n'
        '  processingTime: ${processingTimeMs}ms,\n'
        '  characters: $characterCount,\n'
        '  words: $wordCount,\n'
        '  lines: $lineCount\n'
        '}';
  }
}
