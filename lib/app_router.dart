import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:myapp/home_screen.dart';
import 'package:myapp/login_screen.dart';
import 'package:myapp/register_screen.dart';
import 'package:myapp/iphone_recommendation_screen.dart';
import 'package:myapp/samsung_recommendation_screen.dart';

final router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/brand/:name',
      builder: (context, state) {
        final brandName = state.pathParameters['name']!;
        if (brandName == 'Apple') {
          return const IphoneRecommendationScreen();
        } else if (brandName == 'Samsung') {
          return const SamsungRecommendationScreen();
        } else {
          // Placeholder for other brand detail pages
          return Scaffold(
            appBar: AppBar(title: Text(brandName)),
            body: Center(child: Text('Details for $brandName coming soon!')),
          );
        }
      },
    ),
  ],
);
