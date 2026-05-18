// TODO: Add code here
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// अपनी होम स्क्रीन का सही पाथ इम्पोर्ट करें
import 'package:tao_boost/features/home/presentation/screens/home_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/', // ऐप खुलते ही सबसे पहले क्या दिखेगा
    routes: [
      // 1. Landing / Home Screen Route
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
      
      // 2. Dashboard Route (अभी के लिए डमी विजेट, जब आप बनाओगे तो बदल देना)
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Dashboard Screen coming soon...')),
        ),
      ),
      
      // 3. Staking Route
      GoRoute(
        path: '/staking',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Staking Screen coming soon...')),
        ),
      ),
    ],
    
    // अगर कोई गलत URL डाल दे (वेब पर), तो एरर पेज
    errorBuilder: (context, state) => const Scaffold(
      body: Center(child: Text('Page Not Found!')),
    ),
  );
}