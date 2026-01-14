import 'package:cloud_firestore/cloud_firestore.dart';

/// Helper untuk memudahkan menambah data HP ke Firestore
/// Bisa digunakan untuk batch import atau single add
class FirebaseHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Menambah satu smartphone ke Firestore
  /// Returns document ID jika berhasil
  Future<String?> addSmartphone(Map<String, dynamic> data) async {
    try {
      // Pastikan ada field 'id'
      if (!data.containsKey('id') || data['id'] == null) {
        throw Exception('Field "id" harus diisi');
      }

      await _firestore
          .collection('smartphones')
          .doc(data['id'] as String)
          .set(data);

      return data['id'] as String;
    } catch (e) {
      print('Error adding smartphone: $e');
      return null;
    }
  }

  /// Batch add multiple smartphones
  /// Lebih efisien untuk menambah banyak data sekaligus
  Future<bool> addSmartphonesBatch(List<Map<String, dynamic>> phones) async {
    try {
      final batch = _firestore.batch();

      for (var phone in phones) {
        if (!phone.containsKey('id') || phone['id'] == null) {
          print('Skipping phone without id: ${phone['name']}');
          continue;
        }

        final docRef = _firestore
            .collection('smartphones')
            .doc(phone['id'] as String);
        batch.set(docRef, phone);
      }

      await batch.commit();
      return true;
    } catch (e) {
      print('Error batch adding smartphones: $e');
      return false;
    }
  }

  /// Update existing smartphone
  Future<bool> updateSmartphone(String id, Map<String, dynamic> updates) async {
    try {
      await _firestore.collection('smartphones').doc(id).update(updates);
      return true;
    } catch (e) {
      print('Error updating smartphone: $e');
      return false;
    }
  }

  /// Delete smartphone
  Future<bool> deleteSmartphone(String id) async {
    try {
      await _firestore.collection('smartphones').doc(id).delete();
      return true;
    } catch (e) {
      print('Error deleting smartphone: $e');
      return false;
    }
  }

  /// Get all smartphones (for debugging)
  Future<List<Map<String, dynamic>>> getAllSmartphones() async {
    try {
      final snapshot = await _firestore.collection('smartphones').get();
      return snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList();
    } catch (e) {
      print('Error getting smartphones: $e');
      return [];
    }
  }
}

/// Template data HP untuk memudahkan copy-paste
class SmartphoneTemplate {
  /// Template minimal untuk quick start
  static Map<String, dynamic> minimal({
    required String id,
    required String name,
    required String brand,
    required double rating,
    required int price,
    required String imageUrl,
    required String description,
    List<String>? categories,
    int rank = 1,
  }) {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'rating': rating,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'features': [],
      'specifications': {},
      'categories': categories ?? [],
      'colors': [],
      'advantages': [],
      'disadvantages': [],
      'rank': rank,
      'releaseDate': DateTime.now().toIso8601String(),
      'antutuScore': 0,
      'viewCount': 0,
      'likeCount': 0,
      'detailViewCount': 0,
      'trendingPercentage': 0,
      'reviews': 0,
    };
  }

  /// Template lengkap dengan spesifikasi
  static Map<String, dynamic> complete({
    required String id,
    required String name,
    required String brand,
    required double rating,
    required int price,
    required String imageUrl,
    required String description,
    required List<String> features,
    required Map<String, dynamic> specifications,
    required List<String> categories,
    required List<String> colors,
    required List<String> advantages,
    required List<String> disadvantages,
    int rank = 1,
    double? antutuScore,
    String? releaseDate,
    String? trendReason,
    int reviews = 0,
  }) {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'rating': rating,
      'price': price,
      'imageUrl': imageUrl,
      'description': description,
      'features': features,
      'specifications': specifications,
      'categories': categories,
      'colors': colors,
      'advantages': advantages,
      'disadvantages': disadvantages,
      'rank': rank,
      'releaseDate': releaseDate ?? DateTime.now().toIso8601String(),
      'antutuScore': antutuScore ?? 0,
      'viewCount': 0,
      'likeCount': 0,
      'detailViewCount': 0,
      'trendingPercentage': 0,
      'trendReason': trendReason,
      'reviews': reviews,
    };
  }
}

