import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:myapp/models/smartphone.dart';
import 'package:myapp/services/smartphone_service.dart';
import 'package:myapp/services/scoring_service.dart';

/// Helper untuk load data dari JSON file
/// Berguna untuk testing atau fallback jika Firestore tidak tersedia
class JsonDataLoader {
  /// Load smartphones dari JSON file dan populate ke service
  static Future<void> loadDataToService(SmartphoneService service) async {
    try {
      final jsonString = await rootBundle.loadString('assets/data/smartphones.json');
      final jsonData = json.decode(jsonString);
      final phonesJson = jsonData['smartphones'] as List<dynamic>;

      // Convert ke Smartphone dengan auto-scoring
      final phones = phonesJson.map((json) {
        return _createSmartphoneWithScoring(json as Map<String, dynamic>);
      }).toList();

      // Load ke service cache
      await service.loadFromJson(phones.map((p) => p.toJson()).toList());
    } catch (e) {
      // Silent fail - akan gunakan empty data
      print('Error loading JSON data: $e');
    }
  }

  /// Create Smartphone dengan auto-calculate scores
  static Smartphone _createSmartphoneWithScoring(Map<String, dynamic> json) {
    final specs = json['specifications'] as Map<String, dynamic>? ?? {};

    // Calculate overall score
    final overallScore = ScoringService.calculateOverallScore(
      performanceScore: (json['antutuScore'] as num?)?.toDouble() ?? 
                        (specs['antutu'] as num?)?.toDouble() ?? 0.0,
      cameraScore: (specs['mainCameraMP'] as num?)?.toDouble() ?? 0.0,
      batteryScore: (specs['battery'] as num?)?.toDouble() ?? 0.0,
      displayScore: (specs['displayScore'] as num?)?.toDouble() ?? 0.5,
      priceScore: ((json['price'] as num?)?.toInt() ?? 0).toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      buildQuality: (specs['buildQuality'] as num?)?.toDouble() ?? 0.5,
    );

    // Calculate trending score
    final releaseDate = json['releaseDate'] != null
        ? DateTime.parse(json['releaseDate'] as String)
        : DateTime.now();
    
    final trendingScore = ScoringService.calculateTrendingScore(
      antutuScore: (json['antutuScore'] as num?)?.toDouble() ?? 
                   (specs['antutu'] as num?)?.toDouble() ?? 0.0,
      viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      detailViewCount: (json['detailViewCount'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      releaseDate: releaseDate,
    );

    // Calculate category scores
    final categoryScores = <String, double>{};
    final categories = List<String>.from(json['categories'] ?? []);
    final brand = json['brand'] as String?;
    for (var category in categories) {
      categoryScores[category] = ScoringService.calculateCategoryScore(
        category: category,
        specs: specs,
        price: (json['price'] as num?)?.toInt() ?? 0,
        rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
        brand: brand,
      );
    }

    // Calculate trending percentage
    final maxTrendingScore = 100.0; // Max possible score
    final trendingPercentage = ScoringService.calculateTrendingPercentage(
      trendingScore,
      maxTrendingScore,
    );

    // Create Smartphone dengan calculated scores
    return Smartphone(
      id: json['id'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      price: json['price'] as int? ?? 0,
      originalPrice: json['originalPrice'] as String?,
      imageUrl: json['imageUrl'] as String? ?? '',
      features: List<String>.from(json['features'] ?? []),
      specifications: specs,
      categories: categories,
      description: json['description'] as String? ?? '',
      colors: List<String>.from(json['colors'] ?? []),
      advantages: List<String>.from(json['advantages'] ?? []),
      disadvantages: List<String>.from(json['disadvantages'] ?? []),
      overallScore: overallScore,
      trendingScore: trendingScore,
      trendingPercentage: trendingPercentage,
      rank: json['rank'] as int? ?? 0,
      categoryScores: categoryScores,
      viewCount: json['viewCount'] as int? ?? 0,
      likeCount: json['likeCount'] as int? ?? 0,
      detailViewCount: json['detailViewCount'] as int? ?? 0,
      releaseDate: releaseDate,
      antutuScore: (json['antutuScore'] as num?)?.toDouble() ?? 
                   (specs['antutu'] as num?)?.toDouble(),
      trendReason: json['trendReason'] as String?,
      reviews: json['reviews'] as int?,
    );
  }
}

