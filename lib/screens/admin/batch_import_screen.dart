import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myapp/utils/firebase_helper.dart';

/// Screen untuk batch import data HP dari JSON ke Firestore
/// Lebih mudah daripada manual entry satu per satu
class BatchImportScreen extends StatefulWidget {
  const BatchImportScreen({super.key});

  @override
  State<BatchImportScreen> createState() => _BatchImportScreenState();
}

class _BatchImportScreenState extends State<BatchImportScreen> {
  final _helper = FirebaseHelper();
  bool _isLoading = false;
  String _status = '';
  int _importedCount = 0;
  int _skippedCount = 0;

  Future<void> _importFromJson() async {
    setState(() {
      _isLoading = true;
      _status = 'Loading JSON file...';
      _importedCount = 0;
      _skippedCount = 0;
    });

    try {
      // Load JSON from assets
      final jsonString = await rootBundle.loadString('assets/data/smartphones.json');
      final jsonData = json.decode(jsonString);
      final phones = jsonData['smartphones'] as List<dynamic>;

      setState(() {
        _status = 'Found ${phones.length} smartphones. Importing...';
      });

      // Convert to List<Map>
      final phonesList = phones
          .map((p) => p as Map<String, dynamic>)
          .where((p) => p['id'] != null && (p['id'] as String).isNotEmpty)
          .toList();

      // Batch import
      final result = await _helper.addSmartphonesBatch(phonesList);

      if (result) {
        setState(() {
          _importedCount = phonesList.length;
          _skippedCount = phones.length - phonesList.length;
          _status = '✅ Import berhasil!';
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Berhasil import $_importedCount HP!'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
            ),
          );
        }
      } else {
        setState(() {
          _status = '❌ Import gagal. Cek console untuk detail.';
        });
      }
    } catch (e) {
      setState(() {
        _status = '❌ Error: $e';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Batch Import HP'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.upload_file, color: Colors.blue.shade700, size: 32),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Batch Import dari JSON',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Import semua data HP dari assets/data/smartphones.json',
                                style: TextStyle(color: Colors.blue.shade900),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Instructions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Cara Pakai',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildInstructionItem('1. Edit file', 'assets/data/smartphones.json'),
                    _buildInstructionItem('2. Tambahkan/edit data HP di JSON'),
                    _buildInstructionItem('3. Klik tombol "Import dari JSON" di bawah'),
                    _buildInstructionItem('4. Data akan langsung masuk ke Firestore!'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Status
            if (_status.isNotEmpty)
              Card(
                color: _status.contains('✅')
                    ? Colors.green.shade50
                    : _status.contains('❌')
                        ? Colors.red.shade50
                        : Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Status',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _status,
                        style: TextStyle(
                          fontSize: 16,
                          color: _status.contains('✅')
                              ? Colors.green.shade900
                              : _status.contains('❌')
                                  ? Colors.red.shade900
                                  : Colors.blue.shade900,
                        ),
                      ),
                      if (_importedCount > 0 || _skippedCount > 0) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            if (_importedCount > 0) ...[
                              Icon(Icons.check_circle, color: Colors.green, size: 20),
                              const SizedBox(width: 4),
                              Text('Berhasil: $_importedCount'),
                              const SizedBox(width: 16),
                            ],
                            if (_skippedCount > 0) ...[
                              Icon(Icons.warning, color: Colors.orange, size: 20),
                              const SizedBox(width: 4),
                              Text('Dilewati: $_skippedCount'),
                            ],
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

            const SizedBox(height: 24),

            // Import Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _importFromJson,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Icon(Icons.upload_file),
              label: Text(_isLoading ? 'Importing...' : 'Import dari JSON'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey,
              ),
            ),

            const SizedBox(height: 16),

            // Warning
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '⚠️ Data yang sudah ada dengan ID yang sama akan di-overwrite!',
                        style: TextStyle(color: Colors.orange.shade900),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionItem(String text, [String? subtitle]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontSize: 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 4.0),
                    child: Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

