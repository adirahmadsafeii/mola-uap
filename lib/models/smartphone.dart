/// Model untuk data smartphone
/// Berisi semua informasi smartphone termasuk spesifikasi, scoring, dan trending
class Smartphone {
  final String id;
  final String name;
  final String brand; // Apple, Samsung, Xiaomi, dll
  final double rating;
  final int price;
  final String? originalPrice; // Harga asli jika ada diskon
  final String imageUrl;
  final List<String> features; // ["A17 Pro", "48MP Camera", "Titanium"]
  final Map<String, dynamic> specifications; // Full specs GSMArena style
  final List<String> categories; // ["Gaming", "Kamera", "2 Jutaan", "3 Jutaan", "4 Jutaan"]
  final String description;
  final List<String> colors; // Available colors
  final List<String> advantages; // Kelebihan
  final List<String> disadvantages; // Kekurangan
  
  // Scoring fields
  final double overallScore; // Score keseluruhan untuk ranking
  final double trendingScore; // Score untuk trending
  final int trendingPercentage; // Trending % untuk display
  final int rank; // Rank per brand atau kategori
  final Map<String, double> categoryScores; // Score per kategori
  
  // Analytics fields (untuk trending calculation)
  final int viewCount;
  final int likeCount;
  final int detailViewCount;
  final DateTime releaseDate;
  final double? antutuScore; // AnTuTu benchmark
  
  // Trending display
  final String? trendReason; // Alasan trending
  final int? reviews; // Jumlah review

  Smartphone({
    required this.id,
    required this.name,
    required this.brand,
    required this.rating,
    required this.price,
    this.originalPrice,
    required this.imageUrl,
    required this.features,
    required this.specifications,
    required this.categories,
    required this.description,
    required this.colors,
    required this.advantages,
    required this.disadvantages,
    required this.overallScore,
    required this.trendingScore,
    required this.trendingPercentage,
    required this.rank,
    required this.categoryScores,
    this.viewCount = 0,
    this.likeCount = 0,
    this.detailViewCount = 0,
    required this.releaseDate,
    this.antutuScore,
    this.trendReason,
    this.reviews,
  });

  /// Factory constructor dari JSON
  factory Smartphone.fromJson(Map<String, dynamic> json) {
    return Smartphone(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unknown',
      brand: json['brand'] as String? ?? 'Unknown',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      price: json['price'] as int? ?? 0,
      originalPrice: json['originalPrice'] as String?,
      imageUrl: json['imageUrl'] as String? ?? '',
      features: (json['features'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      specifications: json['specifications'] as Map<String, dynamic>? ?? {},
      categories: (json['categories'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      description: json['description'] as String? ?? '',
      colors: (json['colors'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      advantages: (json['advantages'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      disadvantages: (json['disadvantages'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      overallScore: (json['overallScore'] as num?)?.toDouble() ?? 0.0,
      trendingScore: (json['trendingScore'] as num?)?.toDouble() ?? 0.0,
      trendingPercentage: json['trendingPercentage'] as int? ?? 0,
      rank: json['rank'] as int? ?? 0,
      categoryScores: (json['categoryScores'] as Map<String, dynamic>?)
              ?.map((key, value) => MapEntry(key, (value as num?)?.toDouble() ?? 0.0)) ??
          {},
      viewCount: json['viewCount'] as int? ?? 0,
      likeCount: json['likeCount'] as int? ?? 0,
      detailViewCount: json['detailViewCount'] as int? ?? 0,
      releaseDate: json['releaseDate'] != null
          ? DateTime.tryParse(json['releaseDate'] as String) ?? DateTime.now()
          : DateTime.now(),
      antutuScore: (json['antutuScore'] as num?)?.toDouble(),
      trendReason: json['trendReason'] as String?,
      reviews: json['reviews'] as int?,
    );
  }

  /// Convert ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand': brand,
      'rating': rating,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'features': features,
      'specifications': specifications,
      'categories': categories,
      'description': description,
      'colors': colors,
      'advantages': advantages,
      'disadvantages': disadvantages,
      'overallScore': overallScore,
      'trendingScore': trendingScore,
      'trendingPercentage': trendingPercentage,
      'rank': rank,
      'categoryScores': categoryScores,
      'viewCount': viewCount,
      'likeCount': likeCount,
      'detailViewCount': detailViewCount,
      'releaseDate': releaseDate.toIso8601String(),
      'antutuScore': antutuScore,
      'trendReason': trendReason,
      'reviews': reviews,
    };
  }

  /// Format harga untuk display
  String get formattedPrice {
    return 'Rp ${price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  /// Format original price jika ada
  String? get formattedOriginalPrice {
    if (originalPrice == null) return null;
    return 'Rp ${originalPrice!.replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }
}

