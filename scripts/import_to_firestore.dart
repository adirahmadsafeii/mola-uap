import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/firebase_options.dart';

/// Script untuk batch import data HP dari JSON ke Firestore
/// 
/// Cara pakai:
/// 1. Pastikan sudah setup Firebase
/// 2. Jalankan: dart run scripts/import_to_firestore.dart
/// 
/// Script akan membaca file assets/data/smartphones.json
/// dan import semua data ke Firestore collection 'smartphones'

Future<void> main() async {
  print('🔥 Starting Firebase import...\n');

  try {
    // Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print('✅ Firebase initialized\n');

    // Read JSON file
    // Try multiple possible paths
    final possiblePaths = [
      'assets/data/smartphones.json',
      'lib/../assets/data/smartphones.json',
      File(Platform.script.toFilePath()).parent.parent.path + '/assets/data/smartphones.json',
    ];

    File? jsonFile;
    for (var path in possiblePaths) {
      final file = File(path);
      if (await file.exists()) {
        jsonFile = file;
        break;
      }
    }

    if (jsonFile == null) {
      print('❌ File not found: assets/data/smartphones.json');
      print('   Tried paths:');
      for (var path in possiblePaths) {
        print('   - $path');
      }
      print('\n   Make sure you run this from project root directory');
      exit(1);
    }

    print('📂 Reading file: ${jsonFile.path}\n');
    final jsonString = await jsonFile.readAsString();
    final jsonData = json.decode(jsonString);
    final phones = jsonData['smartphones'] as List<dynamic>;

    print('📱 Found ${phones.length} smartphones to import\n');

    // Import to Firestore
    final firestore = FirebaseFirestore.instance;
    int successCount = 0;
    int skipCount = 0;
    int totalPhones = phones.length;
    
    // Firestore batch limit is 500, so we can do all in one batch
    final batch = firestore.batch();
    const int batchLimit = 500;
    int currentBatchSize = 0;

    print('📤 Importing to Firestore...\n');
    
    for (int i = 0; i < phones.length; i++) {
      final phoneData = phones[i];
      final phone = phoneData as Map<String, dynamic>;
      final id = phone['id'] as String?;

      if (id == null || id.isEmpty) {
        print('⚠️  Skipping phone without id: ${phone['name'] ?? 'Unknown'}');
        skipCount++;
        continue;
      }

      // Add to batch (will overwrite if document exists)
      final docRef = firestore.collection('smartphones').doc(id);
      batch.set(docRef, phone);
      successCount++;
      currentBatchSize++;

      // Progress indicator
      final progress = ((i + 1) / totalPhones * 100).toStringAsFixed(1);
      print('[$progress%] ✅ Added: ${phone['name']} (${phone['brand']})');

      // Commit batch if reaching limit (shouldn't happen with 43 phones, but safety check)
      if (currentBatchSize >= batchLimit) {
        print('\n📤 Committing batch ($currentBatchSize documents)...');
        await batch.commit();
        currentBatchSize = 0;
      }
    }

    // Commit remaining batch
    if (currentBatchSize > 0) {
      print('\n📤 Committing final batch ($currentBatchSize documents)...');
      await batch.commit();
    }

    print('\n🎉 Import completed!');
    print('   ✅ Success: $successCount');
    if (skipCount > 0) {
      print('   ⚠️  Skipped: $skipCount');
    }
    print('\n💡 Check Firebase Console to verify:');
    print('   https://console.firebase.google.com/project/smartphone-rec/firestore');
  } catch (e, stackTrace) {
    print('\n❌ Error: $e');
    print('\nStack trace:');
    print(stackTrace);
    exit(1);
  }
}

