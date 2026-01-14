import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/services/auth_service.dart';

/// Widget sidebar (drawer) untuk navigasi aplikasi
/// Menampilkan menu utama dan kategori smartphone sesuai desain Figma
class Sidebar extends StatefulWidget {
  const Sidebar({super.key});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          _buildHeader(context),
          
          // Menu Utama Section (bisa scroll dan expand)
          Expanded(
            child: _buildMainMenuSection(context),
          ),

          // Footer Section (fixed di bawah)
          _buildFooterSection(context),
        ],
      ),
    );
  }


  /// Widget untuk header dengan background putih
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.menu,
            color: const Color(0xFF1976D2), // Blue color to match design
            size: 24,
          ),
          const SizedBox(width: 8),
          Text(
            'SmartRec',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
          ),
        ],
      ),
    );
  }

  /// Widget untuk section Menu Utama
  Widget _buildMainMenuSection(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // Label Menu Utama
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Menu Utama',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        
        // Menu Items
        _buildMenuItem(
          context: context,
          icon: Icons.home_outlined,
          title: 'Beranda',
          onTap: () {
            Navigator.pop(context);
            context.go('/home');
          },
        ),
        
        _buildMenuItem(
          context: context,
          icon: Icons.trending_up,
          title: 'Trending',
          onTap: () {
            Navigator.pop(context);
            context.go('/trending');
          },
        ),
        
        _buildMenuItem(
          context: context,
          icon: Icons.star_border,
          title: 'Rekomendasi',
          onTap: () {
            Navigator.pop(context);
            context.go('/recommendations');
          },
        ),
        
        // Kategori Collapsible
        _buildCategorySection(context),
      ],
    );
  }

  /// Widget untuk menu item individual
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.black87,
        size: 20,
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 14,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }

  /// Widget untuk section Kategori dengan collapsible
  Widget _buildCategorySection(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        expansionTileTheme: ExpansionTileThemeData(
          collapsedIconColor: Colors.black87,
          iconColor: Colors.black87,
        ),
      ),
      child: ExpansionTile(
        leading: const Icon(
          Icons.category_outlined,
          color: Colors.black87,
          size: 20,
        ),
        title: const Text(
          'Kategori',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        initiallyExpanded: false,
        maintainState: true,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        childrenPadding: EdgeInsets.zero,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: _buildCategorySubItems(context),
      ),
    );
  }

  /// Widget untuk submenu items kategori
  List<Widget> _buildCategorySubItems(BuildContext context) {
    final categoryItems = [
      {'title': 'HP 2 Jutaan Terbaik', 'slug': '2-jutaan'},
      {'title': 'HP 3 Jutaan Terbaik', 'slug': '3-jutaan'},
      {'title': 'HP 4 Jutaan Terbaik', 'slug': '4-jutaan'},
      {'title': 'Gaming Terbaik', 'slug': 'gaming'},
      {'title': 'Kamera Terbaik', 'slug': 'kamera'},
    ];

    return categoryItems.map((item) {
      return ListTile(
        title: Text(
          item['title'] as String,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
        onTap: () {
          Navigator.pop(context);
          context.go('/category/${item['slug']}');
        },
        contentPadding: const EdgeInsets.fromLTRB(48, 4, 16, 4),
      );
    }).toList();
  }

  /// Widget untuk footer section
  Widget _buildFooterSection(BuildContext context) {
    return Column(
      children: [
        const Divider(height: 1),
        ListTile(
          leading: const Icon(
            Icons.info_outline,
            color: Colors.black87,
            size: 20,
          ),
          title: const Text(
            'Tentang',
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14,
            ),
          ),
          onTap: () {
            Navigator.pop(context);
            context.go('/about');
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
        ListTile(
          leading: const Icon(
            Icons.logout,
            color: Colors.red,
            size: 20,
          ),
          title: const Text(
            'Keluar',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
            ),
          ),
          onTap: () async {
            Navigator.pop(context);
            try {
              final authService = AuthService();
              await authService.signOut();
              if (context.mounted) {
                context.go('/login');
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Gagal logout: ${e.toString()}'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        ),
      ],
    );
  }
}
