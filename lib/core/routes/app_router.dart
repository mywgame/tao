import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 📂 ऑथेंटिकेशन और लैंडिंग स्क्रीन्स के एकदम सटीक और सही इम्पोर्ट्स भाई
import 'package:tao_boost/features/auth/views/login_screen.dart';
import 'package:tao_boost/features/auth/views/forgot_password_screen.dart';
import 'package:tao_boost/features/auth/presentation/screens/landing_screen.dart'; 

// 📂 बाकी कोर और फीचर स्क्रीन्स के बिल्कुल सही फोल्डर पाथ
import 'package:tao_boost/features/auth/presentation/screens/dashboard_screen.dart';
import 'package:tao_boost/features/staking/presentation/screens/staking_screen.dart';
import 'package:tao_boost/features/auth/presentation/screens/my_team_screen.dart';
import 'package:tao_boost/features/auth/presentation/screens/k1_club_screen.dart';
import 'package:tao_boost/core/widgets/scaffold_with_nav_bar.dart';

// 🧭 डमी साइन-अप स्क्रीन ताकि जब तक तुम असली फ़ाइल न बनाओ, राउटर एरर न मारे भाई!
class DummySignUpScreen extends StatelessWidget {
  const DummySignUpScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Sign Up Screen Coming Soon', style: TextStyle(color: Colors.white))),
    );
  }
}

// 🧭 ऐप का एकमात्र मुख्य राउटर收藏 कंट्रोलर
final GoRouter appRouter = GoRouter(
  initialLocation: '/', // 👈 ऐप खुलते ही सबसे पहले यूजर लैंडिंग पेज पर जाएगा भाई 🔥
  routes: [
    
    // ==========================================
    // 🎯 1. LANDING SCREEN ROUTE
    // ==========================================
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(), // 👈 अब खुलेगी असली लैंडिंग स्क्रीन!
    ),

    // ==========================================
    // 🔐 2. AUTHENTICATION ROUTES
    // ==========================================
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const DummySignUpScreen(), // 👈 फिक्स! एरर रोकने के लिए डमी लगा दी भाई
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),

    // ==========================================
    // 🏠 3. MAIN APP ROUTES (बॉटम नेविगेशन बार के साथ)
    // ==========================================
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // 1️⃣ Dashboard Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/dashboard',
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        
        // 2️⃣ Stake Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/staking',
              builder: (context, state) => const StakingScreen(),
            ),
          ],
        ),
        
        // 3️⃣ My Team Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/team',
              builder: (context, state) => const MyTeamScreen(),
            ),
          ],
        ),
        
        // 4️⃣ K1 Club Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/k1club',
              builder: (context, state) => const K1ClubScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);