import 'package:go_router/go_router.dart';
import 'package:myapp/screens/auth/login_screen.dart';
import 'package:myapp/screens/auth/register_screen.dart';
import 'package:myapp/screens/home/home_screen.dart';
import 'package:myapp/screens/trending/trending_screen.dart';
import 'package:myapp/screens/recommendations/recommendations_screen.dart';
import 'package:myapp/screens/category/category_screen.dart';
import 'package:myapp/screens/brand/brand_screen.dart';
import 'package:myapp/screens/detail/detail_screen.dart';
import 'package:myapp/screens/admin/add_phone_screen.dart';
import 'package:myapp/screens/admin/batch_import_screen.dart';
import 'package:myapp/screens/about/about_screen.dart';

/// Konfigurasi routing aplikasi menggunakan GoRouter
/// Mengatur semua halaman dan navigasi dalam aplikasi
final navigasi = GoRouter(
  initialLocation: '/login',
  routes: [
    // Halaman autentikasi
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const RegisterScreen(),
    ),

    // Halaman utama
    GoRoute(
      path: '/home',
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),

    // Halaman trending
    GoRoute(
      path: '/trending',
      name: 'trending',
      builder: (context, state) => const TrendingScreen(),
    ),

    // Halaman rekomendasi
    GoRoute(
      path: '/recommendations',
      name: 'recommendations',
      builder: (context, state) => const RecommendationsScreen(),
    ),

    // Halaman kategori
    GoRoute(
      path: '/category/:slug',
      name: 'category',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return CategoryScreen(slug: slug);
      },
    ),

    // Halaman brand
    GoRoute(
      path: '/brand/:slug',
      name: 'brand',
      builder: (context, state) {
        final slug = state.pathParameters['slug']!;
        return BrandScreen(slug: slug);
      },
    ),

    // Halaman detail smartphone
    GoRoute(
      path: '/smartphones/:id',
      name: 'detail',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return DetailScreen(phoneId: id);
      },
    ),

    // Halaman admin (opsional - untuk testing)
    GoRoute(
      path: '/admin/add-phone',
      name: 'add-phone',
      builder: (context, state) => const AddPhoneScreen(),
    ),
    GoRoute(
      path: '/admin/batch-import',
      name: 'batch-import',
      builder: (context, state) => const BatchImportScreen(),
    ),

    // Halaman tentang
    GoRoute(
      path: '/about',
      name: 'about',
      builder: (context, state) => const AboutScreen(),
    ),
  ],
);
