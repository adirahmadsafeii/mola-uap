/// Service untuk menghitung score smartphone berdasarkan berbagai kriteria
class ScoringService {
  /// Calculate overall score untuk ranking umum
  static double calculateOverallScore({
    required double performanceScore, // AnTuTu score
    required double cameraScore, // Camera MP + features
    required double batteryScore, // Battery capacity
    required double displayScore, // Display quality
    required double priceScore, // Value for money (inverse)
    required double rating, // User rating
    required double buildQuality, // Build materials
  }) {
    // Normalize all scores to 0-1 range
    final normalizedPerformance = (performanceScore / 3000000).clamp(0.0, 1.0);
    final normalizedCamera = (cameraScore / 200).clamp(0.0, 1.0); // Max 200MP
    final normalizedBattery = (batteryScore / 6000).clamp(0.0, 1.0); // Max 6000mAh
    final normalizedDisplay = displayScore.clamp(0.0, 1.0);
    final normalizedPrice = (1.0 - (priceScore / 30000000)).clamp(0.0, 1.0); // Inverse
    final normalizedRating = rating / 5.0;
    final normalizedBuild = buildQuality.clamp(0.0, 1.0);

    // Weighted scoring (sesuai metodologi)
    final overallScore = (
      normalizedPerformance * 0.25 + // 25% performa
      normalizedCamera * 0.15 + // 15% kamera
      normalizedBattery * 0.15 + // 15% baterai
      normalizedDisplay * 0.20 + // 20% display
      normalizedPrice * 0.15 + // 15% value
      normalizedRating * 0.15 + // 15% rating
      normalizedBuild * 0.10 // 10% build quality
    ) * 100;

    return overallScore;
  }

  /// Calculate score by category
  static double calculateCategoryScore({
    required String category,
    required Map<String, dynamic> specs,
    required int price,
    required double rating,
    String? brand,
  }) {
    switch (category) {
      case 'Gaming':
        return _calculateGamingScore(specs, price, rating);
      case 'Kamera':
        return _calculateCameraScore(specs, price, rating, brand);
      case '2 Jutaan':
        return _calculateBudgetScore(specs, price, rating, 2000000);
      case '3 Jutaan':
        return _calculateBudgetScore(specs, price, rating, 3000000);
      case '4 Jutaan':
        return _calculateBudgetScore(specs, price, rating, 4000000);
      default:
        return calculateOverallScore(
          performanceScore: (specs['antutu'] as num?)?.toDouble() ?? 0,
          cameraScore: (specs['cameraMP'] as num?)?.toDouble() ?? 0,
          batteryScore: (specs['battery'] as num?)?.toDouble() ?? 0,
          displayScore: (specs['displayScore'] as num?)?.toDouble() ?? 0.5,
          priceScore: price.toDouble(),
          rating: rating,
          buildQuality: (specs['buildQuality'] as num?)?.toDouble() ?? 0.5,
        );
    }
  }

  static double _calculateGamingScore(
    Map<String, dynamic> specs,
    int price,
    double rating,
  ) {
    // Gaming: Prioritas AnTuTu tertinggi (iPhone 17 Pro Max, ROG, dll)
    // AnTuTu adalah faktor utama untuk gaming
    final antutu = ((specs['antutu'] as num?)?.toDouble() ?? 0) / 3000000.0; // Normalize to 0-1
    final ram = ((specs['ram'] as num?)?.toDouble() ?? 0) / 24.0; // Max 24GB
    final cooling = (specs['cooling'] as num?)?.toDouble() ?? 0.5;
    final refreshRate = ((specs['refreshRate'] as num?)?.toInt() ?? 60) / 165.0; // Max 165Hz
    final normalizedRating = rating / 5.0;

    // AnTuTu adalah faktor dominan (50%), karena ini yang menentukan performa gaming
    return (antutu * 0.50 + ram * 0.20 + cooling * 0.15 + refreshRate * 0.10 + normalizedRating * 0.05) * 100;
  }

  static double _calculateCameraScore(
    Map<String, dynamic> specs,
    int price,
    double rating,
    String? brand,
  ) {
    // Kamera: Prioritas iPhone (biasanya terbaik) dan MP tinggi
    final mainMP = ((specs['mainCameraMP'] as num?)?.toDouble() ?? 0) / 200.0;
    final ultrawide = (specs['hasUltrawide'] as bool?) ?? false ? 1.0 : 0.0;
    final telephoto = (specs['hasTelephoto'] as bool?) ?? false ? 1.0 : 0.0;
    final video = (specs['video4K'] as bool?) ?? false ? 1.0 : 0.0;
    final ois = (specs['hasOIS'] as bool?) ?? false ? 1.0 : 0.0;
    final normalizedRating = rating / 5.0;
    
    // Bonus untuk iPhone (biasanya kamera terbaik)
    final brandBonus = (brand?.toLowerCase() == 'apple' || brand?.toLowerCase() == 'iphone') ? 0.15 : 0.0;

    // Main MP adalah faktor utama (35%), iPhone bonus (15%), fitur lainnya
    return (mainMP * 0.35 + brandBonus + ultrawide * 0.12 + telephoto * 0.12 + video * 0.08 + ois * 0.08 + normalizedRating * 0.10) * 100;
  }

  static double _calculateBudgetScore(
    Map<String, dynamic> specs,
    int price,
    double rating,
    int maxPrice,
  ) {
    final performance = ((specs['antutu'] as num?)?.toDouble() ?? 0) / 2000000.0;
    final battery = ((specs['battery'] as num?)?.toDouble() ?? 0) / 5000.0;
    final value = (1.0 - (price / maxPrice.toDouble())).clamp(0.0, 1.0);
    final normalizedRating = rating / 5.0;
    final ram = ((specs['ram'] as num?)?.toDouble() ?? 0) / 12.0;

    return (performance * 0.25 + battery * 0.25 + value * 0.30 + normalizedRating * 0.10 + ram * 0.10) * 100;
  }

  /// Calculate trending score
  static double calculateTrendingScore({
    required double antutuScore,
    required int viewCount,
    required int likeCount,
    required int detailViewCount,
    required double rating,
    required DateTime releaseDate,
  }) {
    // Normalize scores (0-1)
    final normalizedAntutu = (antutuScore / 3000000).clamp(0.0, 1.0);
    final normalizedViews = (viewCount / 10000).clamp(0.0, 1.0);
    final normalizedLikes = (likeCount / 1000).clamp(0.0, 1.0);
    final normalizedDetails = (detailViewCount / 500).clamp(0.0, 1.0);

    // Recency factor (newer phones get boost)
    final daysSinceRelease = DateTime.now().difference(releaseDate).inDays;
    final recencyFactor = daysSinceRelease < 90
        ? 1.0 - (daysSinceRelease / 90) * 0.3
        : 0.7;

    // Weighted calculation
    final score = (
      normalizedAntutu * 0.25 + // 25% performa
      normalizedViews * 0.20 + // 20% views
      normalizedLikes * 0.15 + // 15% likes
      normalizedDetails * 0.15 + // 15% detail views
      rating / 5.0 * 0.15 + // 15% rating
      recencyFactor * 0.10 // 10% recency
    ) * 100;

    return score;
  }

  /// Calculate trending percentage (for display)
  static int calculateTrendingPercentage(double score, double maxScore) {
    return ((score / maxScore) * 100).round();
  }
}

