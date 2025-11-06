import '../models/business_card_data.dart';
import '../parsers/text_parser.dart';

/// Abstract class defining the interface for business card analyzers
/// 
/// This allows for different implementations of business card analysis,
/// such as local regex-based analysis or remote AI-based analysis.
abstract class AnalyzerProvider {
  /// Analyzes the given text and returns structured business card data
  /// 
  /// [text] - The raw text to analyze
  /// Returns a [Future] that completes with a [BusinessCardData] object
  Future<BusinessCardData> analyze(String text);
}

/// Default implementation of [AnalyzerProvider] that uses regex patterns
/// to extract information from business card text.
class LocalRegexAnalyzer implements AnalyzerProvider {
  final TextParser _textParser;
  
  /// Creates a new [LocalRegexAnalyzer] instance
  const LocalRegexAnalyzer() : _textParser = const TextParser();
  
  @override
  Future<BusinessCardData> analyze(String text) async {
    // Delegate to the text parser for basic field extraction
    return _textParser.parse(text);
  }
}

/// Placeholder for future AI-based analyzer
/// 
/// This will be implemented in v2 to provide AI-based analysis of business cards
/// using services like OpenAI, Gemini, or a local LLM.
class RemoteAIAnalyzer implements AnalyzerProvider {
  // TODO(sourav): Implement AI-based analysis in v2
  
  /// Creates a new [RemoteAIAnalyzer] instance
  const RemoteAIAnalyzer();
  
  @override
  Future<BusinessCardData> analyze(String text) async {
    // This is a placeholder for AI-based analysis
    // In v2, this would call an AI service to extract structured data
    return BusinessCardData(rawText: text);
  }
}
