import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/smartphone.dart';
import 'package:myapp/services/smartphone_service.dart';
import 'package:myapp/widgets/sidebar.dart';

/// Halaman brand smartphone
/// Menampilkan HP terbaik dari brand tertentu (Apple, Samsung, Xiaomi, dll)
class BrandScreen extends StatefulWidget {
  final String slug;

  const BrandScreen({super.key, required this.slug});

  @override
  State<BrandScreen> createState() => _BrandScreenState();
}

class _BrandScreenState extends State<BrandScreen> {
  final SmartphoneService _service = SmartphoneService();
  List<Smartphone> _phones = [];
  bool _isLoading = true;

  String get _brandName {
    switch (widget.slug.toLowerCase()) {
      case 'apple':
        return 'Apple';
      case 'samsung':
        return 'Samsung';
      case 'xiaomi':
        return 'Xiaomi';
      case 'oppo':
        return 'OPPO';
      case 'vivo':
        return 'Vivo';
      case 'realme':
        return 'Realme';
      default:
        return widget.slug;
    }
  }

  String get _brandDescription {
    switch (widget.slug.toLowerCase()) {
      case 'apple':
        return 'Smartphone terbaik dari Apple';
      case 'samsung':
        return 'Smartphone terbaik dari Samsung';
      case 'xiaomi':
        return 'Smartphone terbaik dari Xiaomi';
      case 'oppo':
        return 'Smartphone terbaik dari OPPO';
      case 'vivo':
        return 'Smartphone terbaik dari Vivo';
      case 'realme':
        return 'Smartphone terbaik dari Realme';
      default:
        return 'Smartphone terbaik dari ${_brandName}';
    }
  }

  String get _brandTitle {
    switch (widget.slug.toLowerCase()) {
      case 'apple':
        return '5 iPhone Terbaik';
      case 'samsung':
        return '5 Samsung Galaxy Terbaik';
      case 'xiaomi':
        return '5 Xiaomi Terbaik';
      case 'oppo':
        return '5 OPPO Terbaik';
      case 'vivo':
        return '5 Vivo Terbaik';
      case 'realme':
        return '5 Realme Terbaik';
      default:
        return '5 $_brandName Terbaik';
    }
  }



  @override
  void initState() {
    super.initState();
    _loadPhones();
  }

  Future<void> _loadPhones() async {
    setState(() => _isLoading = true);
    try {
      final phones = await _service.getPhonesByBrand(_brandName);
      setState(() {
        _phones = phones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading phones: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartPhone Rec'),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: 'Open navigation menu',
          ),
        ),
      ),
      drawer: const Sidebar(),
      drawerEnableOpenDragGesture: true,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                // Header with Logo
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: _buildBrandLogo(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _brandTitle,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _brandDescription,
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ),
                  const SizedBox(height: 24),

                  // Champion Card
                  if (_phones.isNotEmpty)
                    _buildChampionCard(context, _phones[0]),

                  const SizedBox(height: 24),

                  // Top 5 List
                  Text(
                    _brandTitle,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ..._phones.asMap().entries.map((entry) {
                    final index = entry.key;
                    final phone = entry.value;
                    return _buildPhoneCard(context, phone, index + 1);
                  }),
                ],
              ),
            ),
    );
  }

  Widget _buildBrandLogo() {
    final slug = widget.slug.toLowerCase();
    
    // Map brand slug to logo asset
    final Map<String, String> brandLogos = {
      'samsung': 'assets/images/Samsung-Logo.png',
      'xiaomi': 'assets/images/logo-xiaomi-1536.png',
      'vivo': 'assets/images/vivo-logo-1.png',
      'realme': 'assets/images/realme-logo.png',
    };

    if (brandLogos.containsKey(slug)) {
      return Image.asset(
        brandLogos[slug]!,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) => Icon(Icons.smartphone, size: 64, color: Colors.grey),
      );
    } else if (slug == 'apple') {
      return const Icon(Icons.apple, size: 64, color: Colors.black);
    } else if (slug == 'oppo') {
      return const FittedBox(
        fit: BoxFit.contain,
        child: Text(
          'OPPO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF047857), // Oppo green
          ),
        ),
      );
    }
    
    return const Icon(Icons.smartphone, size: 64, color: Colors.blue);
  }

  Widget _buildChampionCard(BuildContext context, Smartphone phone) {
    return Card(
      color: Colors.blue.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.blue.shade200, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.workspace_premium,
                  color: Colors.blue,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '🏆 Terbaik dari $_brandName',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Phone Image
                SizedBox(
                  width: 80,
                  height: 80,
                  child: phone.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            phone.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.phone_android, size: 40),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.phone_android, size: 40),
                        ),
                ),
                const SizedBox(width: 16),
                // Phone Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phone.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            phone.rating.toStringAsFixed(1),
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade600,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              'Best Choice',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        phone.description,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        phone.formattedPrice,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _service.incrementDetailViewCount(phone.id);
                context.go('/smartphones/${phone.id}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade900,
                foregroundColor: Colors.white,
              ),
              child: const Text('Lihat Detail'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneCard(BuildContext context, Smartphone phone, int rank) {
    Color badgeColor;
    if (rank == 1) {
      badgeColor = Colors.orange;
    } else if (rank == 2) {
      badgeColor = Colors.grey;
    } else if (rank == 3) {
      badgeColor = Colors.orange.shade700;
    } else {
      badgeColor = Colors.blue;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Phone Image with Badge
            Stack(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: phone.imageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            phone.imageUrl,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.phone_android, size: 40),
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.phone_android, size: 40),
                        ),
                ),
                Positioned(
                  top: -8,
                  left: -8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$rank',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),

            // Phone Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              phone.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  phone.rating.toStringAsFixed(1),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Features/Specs
                  if (phone.features.isNotEmpty)
                    Wrap(
                      spacing: 4,
                      runSpacing: 4,
                      children: phone.features.take(4).map((feature) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            feature,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 11,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                  const SizedBox(height: 8),

                  Text(
                    phone.description,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        phone.formattedPrice,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
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
                        ),
                        child: const Text('Lihat Detail'),
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
