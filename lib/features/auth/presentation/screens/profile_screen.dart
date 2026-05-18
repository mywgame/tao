import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'transaction_history_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // टेस्ट के लिए एक डमी TAO वॉलेट एड्रेस
    const String walletAddress = "5GsnB...W7q9Xzp8YvM4kRbc2hT5";

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A), // हमारा सिग्नेचर डार्क बैकग्राउंड
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'INVESTOR PROFILE',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF38BDF8), letterSpacing: 1.5),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 👤 अवतार और नाम
              Center(
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF38BDF8),
                        shape: BoxShape.circle,
                      ),
                      child: const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFF1E293B),
                        child: Icon(Icons.person_rounded, size: 55, color: Colors.white),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle),
                      child: const Icon(Icons.bolt, size: 16, color: Color(0xFF0F172A)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Alok Kumar',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              const SizedBox(height: 4),
              const Text(
                'Tier: Validator Node Pro',
                style: TextStyle(fontSize: 14, color: Color(0xFF38BDF8), fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 32),

              // 💳 Bittensor (TAO) Wallet Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF334155)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('CONNECTED WALLET', style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1)),
                        Icon(Icons.link_rounded, color: Colors.greenAccent, size: 20),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.account_balance_wallet_rounded, color: Color(0xFF38BDF8), size: 24),
                            SizedBox(width: 12),
                            Text(
                              walletAddress,
                              style: TextStyle(color: Colors.white, fontSize: 14, fontFamily: 'Courier', fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.copy_rounded, color: Color(0xFF64748B), size: 20),
                          onPressed: () {
                            Clipboard.setData(const ClipboardData(text: "5GsnB...W7q9Xzp8YvM4kRbc2hT5"));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Wallet Address Copied to Clipboard! 📋'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ⚙️ सेटिंग्स लिस्ट
              _buildSettingTile(Icons.security_rounded, 'Security & 2FA', 'Secure your staking nodes'),
              _buildSettingTile(Icons.lan_rounded, 'Connected Subnets', 'Subnet 1, Subnet 18 active'),
              
              // 🎯 ट्रांजैक्शन हिस्ट्री टाइल (Perfected)
              _buildSettingTile(
                Icons.history_toggle_off_rounded, 
                'Transaction History', 
                'View all reward distributions',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TransactionHistoryScreen()),
                  );
                },
              ),
              _buildSettingTile(Icons.help_outline_rounded, 'Support & Docs', 'Bittensor staking guide'),
              
              const SizedBox(height: 32),
              // 🚪 लॉगआउट बटन
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.redAccent, width: 1),
                    ),
                  ),
                  child: const Text('Disconnect Wallet', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🚀 हेल्पिंग विजेट फंक्शन
  Widget _buildSettingTile(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF38BDF8)),
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(color: Color(0xFF64748B), fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF334155), size: 14),
        onTap: onTap,
      ),
    );
  }
} // 🔥 ये रहा वो आख़िरी छुपेरुस्तम ब्रैकेट जो क्लास को बंद कर रहा है!