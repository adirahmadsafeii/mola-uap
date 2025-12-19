import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartPhone Rec'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go('/login'),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroSection(context),
            const SizedBox(height: 24),
            _buildBrandSection(context),
            const SizedBox(height: 24),
            _buildRecommendationSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6E56FF), Color(0xFF4329E5)],
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
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Rekomendasi terbaik berdasarkan kebutuhan dan budget',
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Brand Smartphone',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildBrandCard(context, 'Apple', 'https://upload.wikimedia.org/wikipedia/commons/f/fa/Apple_logo_black.svg'),
            _buildBrandCard(context, 'Samsung', 'https://upload.wikimedia.org/wikipedia/commons/2/24/Samsung_Logo.svg'),
            _buildBrandCard(context, 'Xiaomi', 'https://upload.wikimedia.org/wikipedia/commons/a/ae/Xiaomi_logo_%282021-%29.svg'),
            _buildBrandCard(context, 'OPPO', 'https://upload.wikimedia.org/wikipedia/commons/a/a2/OPPO_Logo.svg'),
            _buildBrandCard(context, 'Vivo', 'https://upload.wikimedia.org/wikipedia/commons/e/e5/Vivo_logo.svg'),
            _buildBrandCard(context, 'Realme', 'https://upload.wikimedia.org/wikipedia/commons/c/c3/Realme_logo.svg'),
          ],
        ),
      ],
    );
  }

  Widget _buildBrandCard(BuildContext context, String name, String logoUrl) {
    return GestureDetector(
      onTap: () => context.go('/brand/$name'),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 40, child: Image.network(logoUrl, fit: BoxFit.contain, errorBuilder: (c, o, s) => const Icon(Icons.error))),
              const SizedBox(height: 8),
              Text(name, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              Text('5 HP Terbaik', style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendationSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rekomendasi Teratas',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),
        _buildRecommendationCard(
          context,
          'iPhone 15 Pro',
          'Apple',
          '4.8',
          '18.999.000',
          ['A17 Pro', '48MP Camera', 'Titanium'],
          'https://store.storeimages.cdn-apple.com/4982/as-images.apple.com/is/iphone-15-pro-finish-select-202309-6-1inch-naturaltitanium?wid=2560&hei=1440&fmt=p-jpg&qlt=80&.v=1692845702708'
        ),
        const SizedBox(height: 16),
        _buildRecommendationCard(
          context,
          'Samsung Galaxy S24 Ultra',
          'Samsung',
          '4.7',
          '19.999.000',
          ['Snapdragon 8 Gen 3', '200MP Camera', 'S Pen'],
          'https://images.samsung.com/is/image/samsung/p6pim/id/2401/gallery/id-galaxy-s24-ultra-sm-s928bztgxid-539304141?%24650_519_PNG%24'
        ),
      ],
    );
  }

  Widget _buildRecommendationCard(
      BuildContext context, String name, String brand, String rating, String price, List<String> specs, String imageUrl) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SizedBox(
                width: 100, 
                height: 120, 
                child: Image.network(imageUrl, fit: BoxFit.contain, errorBuilder: (context, error, stackTrace) => const Icon(Icons.error))
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(child: Text(name, style: Theme.of(context).textTheme.titleLarge)),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: <TextSpan>[
                            const TextSpan(text: 'Rp ', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                            TextSpan(text: price, style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),
                          ],
                        ),
                      )
                    ],
                  ),
                  Text(brand, style: Theme.of(context).textTheme.bodyMedium),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(rating),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: specs.map((spec) => Chip(
                      label: Text(spec),
                      backgroundColor: Colors.grey.shade200,
                      padding: EdgeInsets.zero,
                    )).toList(),
                  ),
                  const SizedBox(height: 8),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children:[
                        Flexible(
                          child: Text(
                            'Rp $price',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.blue, fontWeight: FontWeight.bold)
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Lihat Detail'),
                        ),
                     ]
                   )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
