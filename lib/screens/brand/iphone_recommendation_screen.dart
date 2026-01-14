import 'package:flutter/material.dart';

/// Halaman rekomendasi iPhone
/// Menampilkan 5 iPhone terbaik dengan detail spesifikasi
class IphoneRecommendationScreen extends StatelessWidget {
  const IphoneRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('5 iPhone Terbaik'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopChoiceCard(context),
            const SizedBox(height: 24),
            Text(
              '5 iPhone Terbaik',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildIphoneCard(
              context,
              '#1',
              'iPhone 15 Pro Max',
              '4.9',
              ['A17 Pro', '256GB', '48MP Pro', '6.7 inch'],
              'Flagship terbaik dengan A17 Pro dan kamera 5x telephoto',
              '21.999.000',
              'assets/images/iphone_15_pro_max.png',
            ),
            _buildIphoneCard(
              context,
              '#2',
              'iPhone 15 Pro',
              '4.8',
              ['A17 Pro', '128GB', '48MP Pro', '6.1 inch'],
              'Performa flagship dalam ukuran yang compact',
              '18.999.000',
              'assets/images/iphone_15_pro.png',
            ),
            _buildIphoneCard(
              context,
              '#3',
              'iPhone 15',
              '4.6',
              ['A16 Bionic', '128GB', '48MP', '6.1 inch'],
              'iPhone terjangkau dengan chip A16 Bionic',
              '13.999.000',
              'assets/images/iphone_15.png',
            ),
            _buildIphoneCard(
              context,
              '#4',
              'iPhone 14',
              '4.5',
              ['A15 Bionic', '128GB', '12MP Dual', '6.1 inch'],
              'Value terbaik dengan performa yang masih excellent',
              '11.999.000',
              'assets/images/iphone_14.png',
            ),
            _buildIphoneCard(
              context,
              '#5',
              'iPhone SE 3',
              '4.3',
              ['A15 Bionic', '64GB', '12MP', '4.7 inch'],
              'iPhone termurah dengan performa flagship',
              '7.999.000',
              'assets/images/iphone_se_3.png',
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk card pilihan terbaik
  Widget _buildTopChoiceCard(BuildContext context) {
    return Card(
      elevation: 2,
      color: Colors.deepPurple.shade50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.workspace_premium,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 8),
                Text(
                  'Terbaik dari iPhone',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 120,
                  child: Image.asset(
                    'assets/images/iphone_15_pro_max.png',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.phone_android),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'iPhone 15 Pro Max',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          const Text('4.9'),
                          const SizedBox(width: 8),
                          Chip(
                            label: const Text(
                              'Best Choice',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                            backgroundColor: Colors.deepPurple,
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Flagship terbaik dengan A17 Pro dan kamera 5x telephoto',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Rp 21.999.000',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: () {
                            // TODO: Implementasi navigasi ke detail
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Lihat Detail'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Widget untuk card iPhone individual
  Widget _buildIphoneCard(
    BuildContext context,
    String rank,
    String name,
    String rating,
    List<String> specs,
    String description,
    String price,
    String imageUrl,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    rank,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleLarge,
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
                          Text(rating),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 60,
                  height: 80,
                  child: Image.asset(
                    imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.phone_android),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: specs
                  .map(
                    (spec) => Chip(
                      label: Text(
                        spec,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.grey.shade200,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rp $price',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implementasi navigasi ke detail
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Lihat Detail'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

