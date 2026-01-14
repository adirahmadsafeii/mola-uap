import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/models/smartphone.dart';
import 'package:myapp/services/smartphone_service.dart';
import 'package:myapp/widgets/sidebar.dart';

/// Halaman kategori smartphone
/// Menampilkan HP terbaik berdasarkan kategori (2/3/4 Jutaan, Gaming, Kamera)
class CategoryScreen extends StatefulWidget {
  final String slug;

  const CategoryScreen({super.key, required this.slug});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final SmartphoneService _service = SmartphoneService();
  List<Smartphone> _phones = [];
  bool _isLoading = true;

  String get _categoryName {
    switch (widget.slug) {
      case '2-jutaan':
        return '2 Jutaan';
      case '3-jutaan':
        return '3 Jutaan';
      case '4-jutaan':
        return '4 Jutaan';
      case 'gaming':
        return 'Gaming';
      case 'kamera':
        return 'Kamera';
      default:
        return widget.slug;
    }
  }

  String get _categoryDescription {
    switch (widget.slug) {
      case '2-jutaan':
        return 'Smartphone terbaik dengan budget di bawah 2 juta rupiah';
      case '3-jutaan':
        return 'Smartphone terbaik dengan budget 2-3 juta rupiah';
      case '4-jutaan':
        return 'Smartphone terbaik dengan budget 3-4 juta rupiah';
      case 'gaming':
        return 'Smartphone terbaik untuk gaming mobile';
      case 'kamera':
        return 'Smartphone dengan sistem kamera terdepan';
      default:
        return 'Smartphone terbaik dalam kategori ini';
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPhones();
  }

  @override
  void didUpdateWidget(CategoryScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reload data jika slug berubah
    if (oldWidget.slug != widget.slug) {
      _loadPhones();
    }
  }

  Future<void> _loadPhones() async {
    setState(() => _isLoading = true);
    try {
      List<Smartphone> phones;
      
      // Filter berdasarkan harga untuk kategori 2/3/4 jutaan
      if (widget.slug == '2-jutaan') {
        phones = await _service.getPhonesByPriceRange(2000000, 2999999, limit: 5);
      } else if (widget.slug == '3-jutaan') {
        phones = await _service.getPhonesByPriceRange(3000000, 3999999, limit: 5);
      } else if (widget.slug == '4-jutaan') {
        phones = await _service.getPhonesByPriceRange(4000000, 4999999, limit: 5);
      } else {
        // Untuk kategori Gaming, Kamera, dll menggunakan category filter
        phones = await _service.getPhonesByCategory(_categoryName, limit: 5);
      }
      
      print('Loaded ${phones.length} phones for category "$_categoryName" (slug: ${widget.slug})');

      setState(() {
        _phones = phones;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error loading phones for category "$_categoryName": $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading phones: $e')),
        );
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
            onPressed: () => Scaffold.of(context).openDrawer(),
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
                  // Header
                  Text(
                    'HP $_categoryName Terbaik',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _categoryDescription,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  const SizedBox(height: 24),

                  // Champion Card
                  if (_phones.isNotEmpty) _buildChampionCard(context, _phones[0]),

                  const SizedBox(height: 24),

                  // Top 5 List
                  Text(
                    'Top 5 $_categoryName Terbaik',
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

                  const SizedBox(height: 24),

                  // Tips Card
                  _buildTipsCard(context),
                ],
              ),
            ),
    );
  }

  Widget _buildChampionCard(BuildContext context, Smartphone phone) {
    return Card(
      color: Colors.yellow.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.yellow.shade200, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.workspace_premium, color: Colors.amber, size: 24),
                const SizedBox(width: 8),
                Text(
                  '🏆 Juara Kategori',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow.shade900,
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
                      Text(
                        phone.brand,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
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
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade600,
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
                          color: Colors.orange.shade700,
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
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                            Text(
                              phone.brand,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 13,
                    ),
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

  Widget _buildTipsCard(BuildContext context) {
    List<String> tips = [];
    
    if (widget.slug == '2-jutaan' || widget.slug == '3-jutaan' || widget.slug == '4-jutaan') {
      tips = [
        'Prioritaskan RAM minimal 4GB untuk performa yang lancar',
        'Pilih processor yang sudah terbukti seperti Snapdragon atau Helio',
        'Perhatikan kapasitas baterai minimal 4000mAh',
      ];
    } else if (widget.slug == 'gaming') {
      tips = [
        'Pilih HP dengan sistem pendingin yang baik',
        'Refresh rate minimal 90Hz untuk gameplay yang smooth',
        'RAM minimal 8GB untuk gaming yang optimal',
      ];
    } else if (widget.slug == 'kamera') {
      tips = [
        'Perhatikan ukuran sensor kamera utama',
        'Fitur OIS sangat membantu untuk foto dan video',
        'Cek kualitas kamera ultra-wide dan telephoto',
      ];
    }

    if (tips.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.lightbulb_outline, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Tips Memilih',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...tips.map((tip) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• ', style: TextStyle(fontSize: 16)),
                      Expanded(
                        child: Text(
                          tip,
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

