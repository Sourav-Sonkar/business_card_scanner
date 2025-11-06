import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:business_card_scanner/business_card_scanner.dart';

class GeneralOcrDemo extends StatefulWidget {
  const GeneralOcrDemo({super.key});

  @override
  State<GeneralOcrDemo> createState() => _GeneralOcrDemoState();
}

class _GeneralOcrDemoState extends State<GeneralOcrDemo> {
  final GeneralOcrService _ocrService = GeneralOcrService();
  OcrResult? _result;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _ocrService.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      await _processImage(await pickedFile.readAsBytes());
    }
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    
    if (pickedFile != null) {
      await _processImage(await pickedFile.readAsBytes());
    }
  }

  Future<void> _testWithAssetImage() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load the test image from assets
      final ByteData data = await rootBundle.load('assets/test_card.png');
      final Uint8List imageBytes = data.buffer.asUint8List();
      
      await _processImage(imageBytes);
    } catch (e) {
      setState(() {
        _error = 'Error loading test image: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _processImage(Uint8List imageBytes) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      debugPrint('🔍 Processing image with ${imageBytes.length} bytes');
      final result = await _ocrService.extractTextWithMetadata(imageBytes);
      debugPrint('✅ OCR completed: $result');
      
      setState(() {
        _result = result;
      });
    } catch (e) {
      debugPrint('❌ Error processing image: $e');
      setState(() {
        _error = 'Error processing image: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Icon(icon, size: 28, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 6),
            Flexible(
              child: Text(
                value,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('General OCR Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 200.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_error != null)
                    Card(
                      color: Colors.red.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          _error!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ),
                  
                  if (_result != null) ...[
                    // Statistics
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 1.3,
                      mainAxisSpacing: 12.0,
                      crossAxisSpacing: 12.0,
                      children: [
                        _buildStatCard(
                          'Processing Time',
                          '${_result!.processingTimeMs}ms',
                          Icons.timer,
                        ),
                        _buildStatCard(
                          'Characters',
                          '${_result!.characterCount}',
                          Icons.text_fields,
                        ),
                        _buildStatCard(
                          'Words',
                          '${_result!.wordCount}',
                          Icons.article,
                        ),
                        _buildStatCard(
                          'Lines',
                          '${_result!.lineCount}',
                          Icons.format_list_numbered,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Extracted Text
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.text_snippet),
                                const SizedBox(width: 8),
                                Text(
                                  'Extracted Text',
                                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child: SelectableText(
                                _result!.text.isEmpty ? 'No text found' : _result!.text,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    // Lines breakdown
                    if (_result!.lines.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.format_list_bulleted),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Lines (${_result!.lines.length})',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ...(_result!.lines.asMap().entries.map((entry) {
                                final index = entry.key;
                                final line = entry.value;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Center(
                                          child: Text(
                                            '${index + 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          line,
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              })),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ] else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.document_scanner_outlined,
                              size: 64.0,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              'Extract text from any image',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              'Take a photo or choose from gallery to get started',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.grey.shade500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'test',
              onPressed: _testWithAssetImage,
              tooltip: 'Test with Sample Image',
              backgroundColor: Colors.green,
              child: const Icon(Icons.bug_report),
            ),
            const SizedBox(height: 10.0),
            FloatingActionButton(
              heroTag: 'camera',
              onPressed: _takePhoto,
              tooltip: 'Take Photo',
              child: const Icon(Icons.camera_alt),
            ),
            const SizedBox(height: 10.0),
            FloatingActionButton(
              heroTag: 'gallery',
              onPressed: _pickImage,
              tooltip: 'Choose from Gallery',
              child: const Icon(Icons.photo_library),
            ),
          ],
        ),
      ),
    );
  }
}