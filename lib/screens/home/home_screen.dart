import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/smartphone.dart';
import 'package:myapp/services/smartphone_service.dart';
import 'package:myapp/widgets/sidebar.dart';

/// Halaman beranda aplikasi
/// Menampilkan hero section, brand smartphone, dan rekomendasi teratas
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SmartphoneService _service = SmartphoneService();
  List<Smartphone> _featuredPhones = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeaturedPhones();
  }

  Future<void> _loadFeaturedPhones() async {
    setState(() => _isLoading = true);
    try {
      final phones = await _service.getFeaturedPhones(limit: 3);
      setState(() {
        _featuredPhones = phones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      // Silent fail - akan tampil empty list
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartPhone Rec'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Color(0xFF8B5CF6)),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: 'Open navigation menu',
          ),
        ),
      ),
      drawer: const Sidebar(),
      drawerEnableOpenDragGesture: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(context),
            const SizedBox(height: 32),
            _buildBrandSection(context),
            const SizedBox(height: 32),
            _buildRecommendationSection(context),
          ],
        ),
      ),
    );
  }

  /// Widget untuk hero section dengan gradient
  Widget _buildHeroSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Temukan Smartphone Impianmu',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Rekomendasi terbaik berdasarkan kebutuhan dan budget',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk section brand smartphone
  Widget _buildBrandSection(BuildContext context) {
    final brands = [
      {'name': 'Apple', 'slug': 'apple', 'icon': Icons.apple, 'color': Colors.black},
      {'name': 'Samsung', 'slug': 'samsung', 'icon': Icons.phone_android, 'color': const Color(0xFF1428A0)},
      {'name': 'Xiaomi', 'slug': 'xiaomi', 'icon': Icons.phone_android, 'color': const Color(0xFFFF6900)},
      {'name': 'OPPO', 'slug': 'oppo', 'icon': Icons.phone_android, 'color': const Color(0xFF0080FF)},
      {'name': 'Vivo', 'slug': 'vivo', 'icon': Icons.phone_android, 'color': const Color(0xFF415FFF)},
      {'name': 'Realme', 'slug': 'realme', 'icon': Icons.phone_android, 'color': const Color(0xFFFFC107)},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Brand Smartphone',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.85,
          children: brands.map((brand) {
            return _buildBrandCard(
              context,
              brand['name'] as String,
              brand['slug'] as String,
              brand['icon'] as IconData,
              brand['color'] as Color,
            );
          }).toList(),
        ),
      ],
    );
  }

  /// Widget untuk card brand smartphone
  Widget _buildBrandCard(
    BuildContext context,
    String name,
    String slug,
    IconData icon,
    Color iconColor,
  ) {
    // Map brand slug to logo asset
    final Map<String, String> brandLogos = {
      'apple': 'apple',  // Menggunakan icon Apple
      'samsung': 'assets/images/Samsung-Logo.png',
      'xiaomi': 'assets/images/logo-xiaomi-1536.png',
      'oppo': 'oppo',  // Placeholder, gunakan text
      'vivo': 'assets/images/vivo-logo-1.png',
      'realme': 'assets/images/realme-logo.png',
    };

    return GestureDetector(
      onTap: () => context.go('/brand/$slug'),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Brand logo or icon
              SizedBox(
                height: 48,
                child: _buildBrandLogo(slug, brandLogos[slug], icon, iconColor),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '5 HP Terbaik',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper untuk build brand logo
  Widget _buildBrandLogo(String slug, String? logoPath, IconData fallbackIcon, Color iconColor) {
    if (logoPath != null && logoPath.startsWith('assets/')) {
      return Image.asset(
        logoPath,
        height: 48,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(fallbackIcon, size: 48, color: iconColor),
      );
    } else if (slug == 'apple') {
      return Icon(Icons.apple, size: 48, color: iconColor);
    } else if (slug == 'oppo') {
      return Text(
        'OPPO',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: iconColor,
        ),
      );
    } else {
      return Icon(fallbackIcon, size: 48, color: iconColor);
    }
  }

  /// Widget untuk section rekomendasi teratas
  Widget _buildRecommendationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Rekomendasi Teratas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
            ),
            TextButton(
              onPressed: () => context.go('/recommendations'),
              child: const Text('Lihat Semua'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isLoading)
          const Center(child: CircularProgressIndicator())
        else if (_featuredPhones.isEmpty)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Text('Belum ada data smartphone'),
            ),
          )
        else
          ..._featuredPhones.map((phone) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: _buildRecommendationCard(context, phone),
            );
          }),
      ],
    );
  }

  /// Widget untuk card rekomendasi smartphone
  Widget _buildRecommendationCard(BuildContext context, Smartphone phone) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200, width: 1),
      ),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phone Image
            SizedBox(
              width: 100,
              height: 120,
              child: phone.imageUrl.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        phone.imageUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.phone_android, size: 48, color: Colors.grey.shade400),
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(Icons.phone_android, size: 48, color: Colors.grey.shade400),
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan nama dan harga di kanan atas
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              phone.name,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              phone.brand,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      // Harga di kanan atas
                      Text(
                        phone.formattedPrice,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Rating
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber.shade600, size: 18),
                      const SizedBox(width: 4),
                      Text(
                        phone.rating.toStringAsFixed(1),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Badge spesifikasi
                  if (phone.features.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: phone.features.take(3).map((spec) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            spec,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  fontSize: 11,
                                  color: Colors.grey.shade700,
                                ),
                          ),
                        );
                      }).toList(),
                    ),
                  const SizedBox(height: 12),
                  // Footer dengan harga dan button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        phone.formattedPrice,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _service.incrementDetailViewCount(phone.id);
                          context.go('/smartphones/${phone.id}');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey.shade900,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Lihat Detail',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
