import 'package:flutter/material.dart';
import 'package:myapp/models/smartphone.dart';
import 'package:myapp/services/smartphone_service.dart';
import 'package:myapp/widgets/sidebar.dart';

/// Halaman detail smartphone
/// Menampilkan spesifikasi lengkap GSMArena style
class DetailScreen extends StatefulWidget {
  final String phoneId;

  const DetailScreen({super.key, required this.phoneId});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final SmartphoneService _service = SmartphoneService();
  Smartphone? _phone;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPhoneDetail();
  }

  Future<void> _loadPhoneDetail() async {
    setState(() => _isLoading = true);
    try {
      final phone = await _service.getPhoneDetail(widget.phoneId);
      if (phone != null) {
        await _service.incrementDetailViewCount(phone.id);
      }
      setState(() {
        _phone = phone;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading phone detail: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartPhone Rec'),
      ),
      drawer: const Sidebar(),
      drawerEnableOpenDragGesture: true,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _phone == null
              ? const Center(child: Text('Phone not found'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      _buildHeader(context, _phone!),
                      const SizedBox(height: 24),

                      // Image and Price Section
                      _buildImageAndPriceSection(context, _phone!),
                      const SizedBox(height: 24),

                      // Specifications
                      _buildSpecificationsSection(context, _phone!),
                      const SizedBox(height: 24),

                      // Pros and Cons
                      _buildProsAndConsSection(context, _phone!),
                    ],
                  ),
                ),
    );
  }

  Widget _buildHeader(BuildContext context, Smartphone phone) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${phone.brand} ${phone.name}',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 4),
            Text(
              phone.rating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (phone.reviews != null) ...[
              const SizedBox(width: 8),
              Text(
                '(${phone.reviews} reviews)',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
            ],
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade300),
              ),
              child: Text(
                'Tersedia',
                style: TextStyle(
                  color: Colors.green.shade700,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImageAndPriceSection(BuildContext context, Smartphone phone) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Phone Image
        Expanded(
          flex: 2,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: phone.imageUrl.isNotEmpty
                ? Image.network(
                    phone.imageUrl,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.phone_android, size: 80),
                  )
                : Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.phone_android, size: 80),
                  ),
          ),
        ),
        const SizedBox(width: 16),

        // Price and Colors
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                phone.formattedPrice,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
              if (phone.formattedOriginalPrice != null) ...[
                const SizedBox(height: 4),
                Text(
                  phone.formattedOriginalPrice!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey.shade600,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              const Text(
                'Warna Tersedia:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: phone.colors.map((color) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      color,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 13,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpecificationsSection(BuildContext context, Smartphone phone) {
    if (phone.specifications.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Spesifikasi Lengkap',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...phone.specifications.entries.map((entry) {
          return _buildSpecCategory(context, entry.key, entry.value);
        }),
      ],
    );
  }

  Widget _buildSpecCategory(BuildContext context, String category, dynamic specs) {
    if (specs is! Map<String, dynamic>) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Category Header
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade600,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Text(
              category,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),

          // Specs List
          ...specs.entries.map((spec) {
            final isEven = specs.keys.toList().indexOf(spec.key) % 2 == 0;
            return Container(
              decoration: BoxDecoration(
                color: isEven ? Colors.grey.shade50 : Colors.white,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        border: Border(
                          right: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Text(
                        spec.key,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        spec.value.toString(),
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProsAndConsSection(BuildContext context, Smartphone phone) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pros
        Expanded(
          child: Card(
            color: Colors.green.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Kelebihan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...phone.advantages.map((advantage) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '+ ',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              advantage,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Cons
        Expanded(
          child: Card(
            color: Colors.red.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.cancel, color: Colors.red, size: 24),
                      const SizedBox(width: 8),
                      Text(
                        'Kekurangan',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...phone.disadvantages.map((disadvantage) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '- ',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              disadvantage,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

