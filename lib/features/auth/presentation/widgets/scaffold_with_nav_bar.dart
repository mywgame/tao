import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 💛 सिग्नेचर गोल्ड/येलो थीम कलर्स भाई (पूरी ऐप से 100% सिंक)
    const primaryYellow = Colors.amber; 
    const darkBackground = Color(0xFF121212); 
    const cardColor = Color(0xFF1E1E1E); 

    return Scaffold(
      backgroundColor: darkBackground,
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.05), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: navigationShell.currentIndex,
          onTap: (index) => _onTap(context, index),
          backgroundColor: cardColor, // 🎯 अब आ गया प्रीमियम डार्क कार्ड कलर
          selectedItemColor: primaryYellow, // 🎯 सिलेक्टेड आइकॉन अब सोने की तरह चमकेगा भाई!
          unselectedItemColor: Colors.white.withOpacity(0.4), // अनसिलेक्टेड आइकॉन थोड़ा डिम रहेगा
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 0.5),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bolt_outlined),
              label: 'Staking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.group_outlined),
              label: 'My Team',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.workspace_premium_rounded),
              label: 'K1 Club',
            ),
          ],
        ),
      ),
    );
  }
}