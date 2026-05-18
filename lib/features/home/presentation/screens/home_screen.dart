import 'package:flutter/material.dart';
import '../../../auth/presentation/screens/dashboard_screen.dart'; // सटीक पाथ 🎯

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1; // डिफ़ॉल्ट रूप से डैशबोर्ड (Index 1) खुला रहेगा

  // तीनों स्क्रीन्स की लिस्ट
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      // 0️⃣ इंडेक्स: होम स्क्रीन (फ्यूचर)
      const Center(
        child: Text(
          'Home Feature Coming Soon 🚀', 
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      
      // 1️⃣ इंडेक्स: आपका चार्ट वाला असली डैशबोर्ड
      const DashboardScreen(),
      
      // 2️⃣ इंडेक्स: प्रीमियम K1 क्लब स्क्रीन
      _buildK1ClubTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Color(0xFF334155), width: 1),
          ),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart_rounded),
              label: 'Dashboard',
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

  // 👑 K1 क्लब का यूआई हेल्पर विधि
  Widget _buildK1ClubTab() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF334155)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3), width: 1.5),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'VIP MEMBERSHIP',
                        style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                      Icon(Icons.workspace_premium, color: Color(0xFFF59E0B), size: 28),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Welcome to K1 Club',
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900), // 🔥 FIX: यहाँ FontWeight.w900 किया गया है
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Unlock elite staking pools, higher APR, and advanced AI intelligence metrics.',
                    style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Exclusive Club Privileges',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 16),
            _buildBenefitRow(Icons.add_moderator, 'Premium Staking Pools', 'Access to validators with 0% commission fees.'),
            _buildBenefitRow(Icons.bolt, 'Boosted Yields', 'Earn up to +2.5% extra APR on your staked TAO.'),
            _buildBenefitRow(Icons.insights, 'AI Analytics', 'Deep-dive metrics and early signals on upcoming subnets.'),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF59E0B),
                  foregroundColor: const Color(0xFF0F172A),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Upgrade to K1 Club', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitRow(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF334155)),
            ),
            child: Icon(icon, color: const Color(0xFFF59E0B), size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}