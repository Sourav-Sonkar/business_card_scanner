import 'dart:io';
import 'dart:typed_data';
import 'package:business_card_scanner/business_card_scanner.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Business Card Scanner',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const BusinessCardScannerScreen(),
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

  Future<void> _processImage(Uint8List imageBytes) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final result = await _scanner.scan(imageBytes);
      setState(() {
        _result = result;
      });
    } catch (e) {
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
            )).toList(),
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
                      child: Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
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
                      child: SelectableText(
                        _result!.rawText,
                        style: const TextStyle(fontFamily: 'monospace'),
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
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'camera',
            onPressed: _takePhoto,
            tooltip: 'Take Photo',
            child: const Icon(Icons.camera_alt),
          ),
          const SizedBox(height: 16.0),
          FloatingActionButton(
            heroTag: 'gallery',
            onPressed: _pickImage,
            tooltip: 'Choose from Gallery',
            child: const Icon(Icons.photo_library),
          ),
        ],
      ),
    );
  }
}
