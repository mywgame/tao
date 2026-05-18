import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// 📂 सभी स्क्रीन्स के सही और सटीक इम्पोर्ट्स
import 'package:tao_boost/features/auth/presentation/screens/dashboard_screen.dart';
import 'package:tao_boost/features/staking/presentation/screens/staking_screen.dart';
import 'package:tao_boost/features/auth/presentation/screens/my_team_screen.dart';
import 'package:tao_boost/features/auth/presentation/screens/k1_club_screen.dart'; // 👑 असली वीआईपी स्क्रीन
import 'package:tao_boost/core/widgets/scaffold_with_nav_bar.dart';
// ❌ पुराने वाले auth/presentation वाले इम्पोर्ट्स हटा देना भाई

// ✅ सही और सटीक इम्पोर्ट्स ये हैं:
// ✅ पुराना गलत इम्पोर्ट हटाकर इसे लगाओ गुरु:
import 'package:tao_boost/features/auth/presentation/screens/my_team_screen.dart';
import 'package:tao_boost/features/staking/presentation/screens/staking_screen.dart';

// 🧭 ऐप का एकमात्र मुख्य राउटर कंट्रोलर (सिर्फ एक बार डिक्लेयर्ड!)
final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard', 
  routes: [
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
        
        // 4️⃣ K1 Club Branch (अब सीधा असली VIP स्क्रीन खुलेगी, नो डमी!)
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

