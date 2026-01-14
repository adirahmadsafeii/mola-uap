import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:myapp/models/smartphone.dart';
import 'package:myapp/services/scoring_service.dart';

/// Service untuk mengelola data smartphone
/// Support Firestore dan bisa fallback ke JSON jika Firestore tidak tersedia
class SmartphoneService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Smartphone>? _cachedPhones;
  bool _isLoadingFromJson = false;

  /// Initialize service by loading from JSON if needed
  Future<void> _ensureDataLoaded() async {
    if (_cachedPhones != null || _isLoadingFromJson) return;
    
    _isLoadingFromJson = true;
    try {
      // Try to load from JSON asset
      final jsonString = await rootBundle.loadString('assets/data/smartphones.json');
      final jsonData = json.decode(jsonString);
      final phonesJson = jsonData['smartphones'] as List<dynamic>;

      _cachedPhones = phonesJson.map((json) {
        final phoneJson = json as Map<String, dynamic>;
        final specs = phoneJson['specifications'] as Map<String, dynamic>? ?? {};

        // Calculate scores
        final overallScore = ScoringService.calculateOverallScore(
          performanceScore: (phoneJson['antutuScore'] as num?)?.toDouble() ??
              (specs['antutu'] as num?)?.toDouble() ?? 0.0,
          cameraScore: (specs['mainCameraMP'] as num?)?.toDouble() ?? 0.0,
          batteryScore: (specs['battery'] as num?)?.toDouble() ?? 0.0,
          displayScore: (specs['displayScore'] as num?)?.toDouble() ?? 0.5,
          priceScore: ((phoneJson['price'] as num?)?.toInt() ?? 0).toDouble(),
          rating: (phoneJson['rating'] as num?)?.toDouble() ?? 0.0,
          buildQuality: (specs['buildQuality'] as num?)?.toDouble() ?? 0.5,
        );

        final releaseDate = phoneJson['releaseDate'] != null
            ? DateTime.parse(phoneJson['releaseDate'] as String)
            : DateTime.now();

        final trendingScore = ScoringService.calculateTrendingScore(
          antutuScore: (phoneJson['antutuScore'] as num?)?.toDouble() ??
              (specs['antutu'] as num?)?.toDouble() ?? 0.0,
          viewCount: (phoneJson['viewCount'] as num?)?.toInt() ?? 0,
          likeCount: (phoneJson['likeCount'] as num?)?.toInt() ?? 0,
          detailViewCount: (phoneJson['detailViewCount'] as num?)?.toInt() ?? 0,
          rating: (phoneJson['rating'] as num?)?.toDouble() ?? 0.0,
          releaseDate: releaseDate,
        );

        final categoryScores = <String, double>{};
        final categories = List<String>.from(phoneJson['categories'] ?? []);
        final brand = phoneJson['brand'] as String?;
        for (var category in categories) {
          categoryScores[category] = ScoringService.calculateCategoryScore(
            category: category,
            specs: specs,
            price: (phoneJson['price'] as num?)?.toInt() ?? 0,
            rating: (phoneJson['rating'] as num?)?.toDouble() ?? 0.0,
            brand: brand,
          );
        }

        final trendingPercentage = ScoringService.calculateTrendingPercentage(
            trendingScore, 100.0);

        return Smartphone.fromJson({
          ...phoneJson,
          'overallScore': overallScore,
          'trendingScore': trendingScore,
          'trendingPercentage': trendingPercentage,
          'categoryScores': categoryScores,
        });
      }).toList();
      
      // Set rank untuk setiap brand berdasarkan overallScore
      _updateRanksByBrand();
    } catch (e) {
      print('Error loading JSON data: $e');
    } finally {
      _isLoadingFromJson = false;
    }
  }

  /// Get phones by brand
  Future<List<Smartphone>> getPhonesByBrand(String brand) async {
    // Try Firebase first - prioritize Firebase data
    try {
      // Gunakan query sederhana tanpa orderBy untuk menghindari kebutuhan composite index
      final snapshot = await _firestore
          .collection('smartphones')
          .where('brand', isEqualTo: brand)
          .get();

      if (snapshot.docs.isNotEmpty) {
        print('Firebase: Found ${snapshot.docs.length} phones for brand "$brand"');
        
        final phones = snapshot.docs
            .map((doc) => Smartphone.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList();
        
        // Sort locally by price (highest first for ranking)
        phones.sort((a, b) => b.price.compareTo(a.price));
        
        return phones.take(5).toList();
      }
    } catch (e) {
      print('Error fetching brand $brand from Firestore: $e');
    }
    
    // Fallback ke cached data dari JSON
    await _ensureDataLoaded();
    
    if (_cachedPhones != null) {
      final filtered = _cachedPhones!
          .where((phone) => phone.brand.toLowerCase() == brand.toLowerCase())
          .toList();
      // Sort berdasarkan harga tertinggi = ranking tertinggi (rank 1 = harga tertinggi)
      filtered.sort((a, b) => b.price.compareTo(a.price));
      print('Fallback to cache: Found ${filtered.length} phones for brand "$brand"');
      return filtered.take(5).toList();
    }
    return [];
  }

  /// Get phone detail by ID
  Future<Smartphone?> getPhoneDetail(String id) async {
    try {
      final doc = await _firestore.collection('smartphones').doc(id).get();
      if (doc.exists) {
        return Smartphone.fromJson({
          'id': doc.id,
          ...doc.data()!,
        });
      }
    } catch (e) {
      // Fallback
      if (_cachedPhones != null) {
        try {
          return _cachedPhones!.firstWhere((phone) => phone.id == id);
        } catch (e) {
          return null;
        }
      }
    }
    return null;
  }

  /// Get trending phones
  Future<List<Smartphone>> getTrendingPhones({int limit = 10}) async {
    // Try Firebase first - prioritize Firebase data
    try {
      // Gunakan query sederhana tanpa orderBy untuk menghindari kebutuhan composite index
      final snapshot = await _firestore
          .collection('smartphones')
          .get();

      if (snapshot.docs.isNotEmpty) {
        print('Firebase: Found ${snapshot.docs.length} phones for trending');
        
        final phones = snapshot.docs
            .map((doc) => Smartphone.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .where((phone) => phone.trendingPercentage > 0)
            .toList();
        
        // Sort locally by trendingPercentage
        phones.sort((a, b) => b.trendingPercentage.compareTo(a.trendingPercentage));
        
        if (phones.isNotEmpty) {
          return phones.take(limit).toList();
        }
      }
    } catch (e) {
      print('Error fetching trending from Firestore: $e');
    }
    
    // Fallback ke cached data dari JSON
    await _ensureDataLoaded();
    
    if (_cachedPhones != null) {
      final filtered = _cachedPhones!
          .where((phone) => phone.trendingPercentage > 0)
          .toList()
        ..sort((a, b) => b.trendingPercentage.compareTo(a.trendingPercentage));
      print('Fallback to cache: Found ${filtered.length} trending phones');
      return filtered.take(limit).toList();
    }
    return [];
  }

  /// Get phones by category
  Future<List<Smartphone>> getPhonesByCategory(String category, {int limit = 5}) async {
    // Try Firebase first - prioritize Firebase data
    try {
      // Gunakan query sederhana tanpa orderBy untuk menghindari kebutuhan composite index
      final snapshot = await _firestore
          .collection('smartphones')
          .where('categories', arrayContains: category)
          .get();

      if (snapshot.docs.isNotEmpty) {
        print('Firebase: Found ${snapshot.docs.length} phones in category "$category"');
        
        final phones = snapshot.docs
            .map((doc) => Smartphone.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList();
        
        // Sort locally by overallScore
        phones.sort((a, b) => b.overallScore.compareTo(a.overallScore));
        
        return phones.take(limit).toList();
      } else {
        print('Firebase: No phones found in category "$category"');
      }
    } catch (e) {
      print('Error fetching from Firestore for category $category: $e');
    }
    
    // Fallback ke cached data dari JSON hanya jika Firebase gagal atau kosong
    await _ensureDataLoaded();
    
    if (_cachedPhones != null) {
      final filtered = _cachedPhones!
          .where((phone) => phone.categories.contains(category))
          .toList();
      
      // Sort berdasarkan categoryScore untuk kategori spesifik
      filtered.sort((a, b) {
        final aScore = a.categoryScores[category] ?? 0.0;
        final bScore = b.categoryScores[category] ?? 0.0;
        return bScore.compareTo(aScore);
      });
      
      print('Fallback to cache: Found ${filtered.length} phones in category "$category"');
      return filtered.take(limit).toList();
    }
    print('No cached phones available for category "$category"');
    return [];
  }

  /// Get phones by price range
  Future<List<Smartphone>> getPhonesByPriceRange(int minPrice, int maxPrice, {int limit = 5}) async {
    // Try Firebase first - prioritize Firebase data
    try {
      // Fetch all and filter locally to avoid composite index issues
      final snapshot = await _firestore
          .collection('smartphones')
          .get();

      if (snapshot.docs.isNotEmpty) {
        final allPhones = snapshot.docs
            .map((doc) => Smartphone.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList();
        
        // Filter by price range locally
        final filtered = allPhones
            .where((phone) => phone.price >= minPrice && phone.price <= maxPrice)
            .toList();
        
        if (filtered.isNotEmpty) {
          print('Firebase: Found ${filtered.length} phones in price range $minPrice-$maxPrice');
          
          // Sort locally by overallScore
          filtered.sort((a, b) {
            final scoreCompare = b.overallScore.compareTo(a.overallScore);
            if (scoreCompare != 0) return scoreCompare;
            return a.price.compareTo(b.price);
          });
          
          return filtered.take(limit).toList();
        }
      }
    } catch (e) {
      print('Error fetching from Firestore for price range $minPrice-$maxPrice: $e');
    }
    
    // Fallback ke cached data dari JSON
    await _ensureDataLoaded();
    
    if (_cachedPhones != null) {
      final filtered = _cachedPhones!
          .where((phone) => phone.price >= minPrice && phone.price <= maxPrice)
          .toList()
        ..sort((a, b) {
          final scoreCompare = b.overallScore.compareTo(a.overallScore);
          if (scoreCompare != 0) return scoreCompare;
          return a.price.compareTo(b.price);
        });
      print('Fallback to cache: Found ${filtered.length} phones in price range $minPrice-$maxPrice');
      return filtered.take(limit).toList();
    }
    print('No cached phones available for price range $minPrice-$maxPrice');
    return [];
  }

  /// Get top 5 best phones overall
  Future<List<Smartphone>> getTop5BestPhones() async {
    // Try Firebase first - prioritize Firebase data
    try {
      final snapshot = await _firestore
          .collection('smartphones')
          .get();

      if (snapshot.docs.isNotEmpty) {
        print('Firebase: Found ${snapshot.docs.length} phones for top 5');
        
        final phones = snapshot.docs
            .map((doc) => Smartphone.fromJson({
                  'id': doc.id,
                  ...doc.data(),
                }))
            .toList();
        
        // Sort locally by overallScore
        phones.sort((a, b) => b.overallScore.compareTo(a.overallScore));
        
        return phones.take(5).toList();
      }
    } catch (e) {
      print('Error fetching top 5 from Firestore: $e');
    }
    
    // Fallback ke cached data dari JSON
    await _ensureDataLoaded();
    
    if (_cachedPhones != null) {
      final sorted = _cachedPhones!.toList()
        ..sort((a, b) => b.overallScore.compareTo(a.overallScore));
      print('Fallback to cache: Found ${sorted.length} phones for top 5');
      return sorted.take(5).toList();
    }
    return [];
  }

  /// Get featured phones (for home screen)
  Future<List<Smartphone>> getFeaturedPhones({int limit = 3}) async {
    // Try Firebase first - prioritize Firebase data
    try {
      final snapshot = await _firestore
          .collection('smartphones')
          .get();

      if (snapshot.docs.isNotEmpty) {
        print('Firebase: Found ${snapshot.docs.length} phones for featured');
        
        final phones = snapshot.docs
            .map((doc) {
              final data = {'id': doc.id, ...doc.data()};
              final phone = Smartphone.fromJson(data);
              print('Featured phone ${phone.name}: imageUrl="${phone.imageUrl}"');
              return phone;
            })
            .toList();
        
        // Sort locally by overallScore
        phones.sort((a, b) => b.overallScore.compareTo(a.overallScore));
        
        final result = phones.take(limit).toList();
        print('Firebase: Returning ${result.length} featured phones');
        return result;
      } else {
        print('Firebase: No phones found for featured');
      }
    } catch (e) {
      print('Error fetching featured from Firestore: $e');
    }
    
    // Fallback ke cached data dari JSON
    await _ensureDataLoaded();
    
    if (_cachedPhones != null) {
      final sorted = _cachedPhones!.toList()
        ..sort((a, b) => b.overallScore.compareTo(a.overallScore));
      print('Fallback to cache: Found ${sorted.length} featured phones');
      return sorted.take(limit).toList();
    }
    return [];
  }

  /// Update rank untuk setiap brand berdasarkan overallScore
  /// Rank sudah ada di JSON, jadi kita hanya perlu memastikan sorting benar
  void _updateRanksByBrand() {
    if (_cachedPhones == null) return;
    
    // Group by brand dan sort by overallScore untuk memastikan rank benar
    final phonesByBrand = <String, List<Smartphone>>{};
    for (var phone in _cachedPhones!) {
      phonesByBrand.putIfAbsent(phone.brand, () => []).add(phone);
    }
    
    // Sort setiap brand by overallScore (descending)
    for (var brandPhones in phonesByBrand.values) {
      brandPhones.sort((a, b) => b.overallScore.compareTo(a.overallScore));
    }
  }

  /// Load phones from JSON (fallback method)
  Future<void> loadFromJson(List<Map<String, dynamic>> jsonData) async {
    _cachedPhones = jsonData.map((json) => Smartphone.fromJson(json)).toList();
    _updateRanksByBrand();
  }

  /// Increment view count
  Future<void> incrementViewCount(String phoneId) async {
    try {
      await _firestore.collection('smartphones').doc(phoneId).update({
        'viewCount': FieldValue.increment(1),
      });
    } catch (e) {
      // Silent fail
    }
  }

  /// Increment detail view count
  Future<void> incrementDetailViewCount(String phoneId) async {
    try {
      await _firestore.collection('smartphones').doc(phoneId).update({
        'detailViewCount': FieldValue.increment(1),
      });
    } catch (e) {
      // Silent fail
    }
  }

  /// Increment like count
  Future<void> incrementLikeCount(String phoneId) async {
    try {
      await _firestore.collection('smartphones').doc(phoneId).update({
        'likeCount': FieldValue.increment(1),
      });
    } catch (e) {
      // Silent fail
    }
  }
}

