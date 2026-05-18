import 'package:flutter/material.dart';
import '../../../auth/presentation/screens/dashboard_screen.dart'; // 🔥 अब पाथ बिल्कुल सटीक है!
import '../../../k1_club/presentation/screens/k1_club_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // डिफ़ॉल्ट रूप से डैशबोर्ड (Index 1) खुला रहेगा

  final List<Widget> _screens = [
    const Center(
      child: Text(
        'Home Feature Coming Soon 🚀', 
        style: TextStyle(color: Colors.white, fontSize: 18),
      ),
    ), 
    const DashboardScreen(), // Index 1
    const K1ClubScreen(),    // Index 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFF334155), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: const Color(0xFF1E293B),
          selectedItemColor: const Color(0xFF38BDF8),
          unselectedItemColor: const Color(0xFF94A3B8),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.workspace_premium_rounded), label: 'K1 Club'),
          ],
        ),
      ),
    );
  }
}