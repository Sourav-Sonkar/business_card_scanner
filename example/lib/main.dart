import 'package:business_card_scanner/business_card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'general_ocr_demo.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OCR Scanner Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Scanner Demo'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                child: Icon(
                  Icons.document_scanner,
                  size: 80,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'OCR Scanner Demo',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Choose your scanning mode',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
            
            // Business Card Scanner
            Card(
              elevation: 4,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: const Icon(Icons.contact_mail, size: 32),
                title: const Text('Business Card Scanner'),
                subtitle: const Text(
                  'Extract contact information from business cards',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const BusinessCardScannerScreen(),
                    ),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // General OCR
            Card(
              elevation: 4,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: const Icon(Icons.text_fields, size: 32),
                title: const Text('General Text Scanner'),
                subtitle: const Text(
                  'Extract text from any image or document',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const GeneralOcrDemo(),
                    ),
                  );
                },
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }
}

class BusinessCardScannerScreen extends StatefulWidget {
  const BusinessCardScannerScreen({super.key});

  @override
  State<BusinessCardScannerScreen> createState() => _BusinessCardScannerScreenState();
}

class _BusinessCardScannerScreenState extends State<BusinessCardScannerScreen> {
  final BusinessCardScanner _scanner = BusinessCardScanner();
  BusinessCardData? _result;
  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _scanner.dispose();
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
      final result = await _scanner.scan(imageBytes);
      debugPrint('✅ Scan completed. Raw text length: ${result.rawText.length}');
      debugPrint('📧 Emails found: ${result.emails.length}');
      debugPrint('📞 Phones found: ${result.phones.length}');
      debugPrint('🌐 URLs found: ${result.urls.length}');
      
      if (result.rawText.isNotEmpty) {
        debugPrint('📝 Raw text preview: ${result.rawText.substring(0, result.rawText.length > 100 ? 100 : result.rawText.length)}');
      }
      
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

  Widget _buildInfoCard(String title, List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            ...items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(item),
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Business Card Scanner'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        color: Colors.red.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            _error!,
                            style: TextStyle(color: Colors.red.shade700),
                            overflow: TextOverflow.visible,
                          ),
                        ),
                      ),
                    ),
                  if (_result != null) ...[
                    _buildInfoCard('Emails', _result!.emails),
                    _buildInfoCard('Phone Numbers', _result!.phones),
                    _buildInfoCard('Websites', _result!.urls),
                    if (_result!.name != null ||
                        _result!.title != null ||
                        _result!.company != null ||
                        _result!.address != null) ...[
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (_result!.name != null) ...[
                              Text(
                                _result!.name!,
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 4.0),
                            ],
                            if (_result!.title != null)
                              Text(
                                _result!.title!,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            if (_result!.company != null)
                              Text(
                                _result!.company!,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            if (_result!.address != null) ...[
                              const SizedBox(height: 8.0),
                              Text(_result!.address!),
                            ],
                          ],
                        ),
                      ),
                    ],
                    const Divider(),
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Raw Text',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12.0),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: SelectableText(
                          _result!.rawText.isEmpty ? 'No text found' : _result!.rawText,
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 14.0,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                  ] else
                    const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.contact_mail_outlined,
                            size: 64.0,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Scan a business card to extract contact information',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18.0, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
      floatingActionButton: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FloatingActionButton(
              heroTag: 'test',
              onPressed: _testWithAssetImage,
              tooltip: 'Test with Asset Image',
              backgroundColor: Colors.green,
              child: const Icon(Icons.bug_report),
            ),
            const SizedBox(height: 12.0),
            FloatingActionButton(
              heroTag: 'camera',
              onPressed: _takePhoto,
              tooltip: 'Take Photo',
              child: const Icon(Icons.camera_alt),
            ),
            const SizedBox(height: 12.0),
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
