import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 16),
            child: Row(
              children: [
                Icon(Icons.menu, color: Theme.of(context).primaryColor),
                const SizedBox(width: 16),
                Text(
                  'SmartRec',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text('Menu Utama', style: TextStyle(color: Colors.grey)),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Beranda'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.trending_up),
            title: const Text('Trending'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.star_border),
            title: const Text('Rekomendasi'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.grid_view_outlined),
            title: const Text('Kategori'),
            initiallyExpanded: true,
            childrenPadding: const EdgeInsets.only(left: 30),
            children: [
              ListTile(
                title: const Text('HP 2 Jutaan Terbaik'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('HP 3 Jutaan Terbaik'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('HP 4 Jutaan Terbaik'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Gaming Terbaik'),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Kamera Terbaik'),
                onTap: () {},
              ),
            ],
          ),
          const Spacer(),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Tentang'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}